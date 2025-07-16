# frozen_string_literal: true

# Patches the `HTTPClient` and `TCPSocket` classes to use a SOCKS5H proxy.
# This class modifies the behavior of `HTTPClient` to route HTTP requests
# through a SOCKS proxy by overriding the socket creation method.
# It also configures `TCPSocket` to use the specified SOCKS proxy server,
# and validates that the provided proxy is correct, resolvable, and accessible.

require "socksify"
require "httpclient"
require "socket" unless defined?(Socket)

class SocksProxyPatch
  # Applies the SOCKS proxy settings to `HTTPClient` and `TCPSocket`.
  #
  # @param socks_proxy [String] The SOCKS proxy address in the format `host:port`.
  # @param socks_user [String, nil] Optional SOCKS proxy username.
  # @param socks_password [String, nil] Optional SOCKS proxy password.
  # @example
  #   SocksProxyPatch.apply(socks_proxy: "127.0.0.1:1080", socks_user: "user", socks_password: "pass")
  def self.apply(socks_proxy:, socks_user: nil, socks_password: nil)
    new(socks_proxy: socks_proxy, socks_user: socks_user, socks_password: socks_password).apply
  end

  def initialize(socks_proxy:, socks_user:, socks_password:)
    @socks_proxy = socks_proxy
    @socks_user = socks_user
    @socks_password = socks_password
  end

  def apply
    @proxy_host, @proxy_port = parse_and_validate_proxy(socks_proxy)
    configure_socks
    patch_http_client
  end

  private

  attr_reader :proxy_host, :proxy_port, :socks_user, :socks_password

  # Parses the proxy string and validates its format, DNS resolution, and port.
  def parse_and_validate_proxy(socks_proxy)
    proxy_host, proxy_port = socks_proxy.split(":")
    proxy_host = proxy_host.to_i

    unless proxy_host && proxy_port
      raise Train::ClientError, "Invalid SOCKS proxy format: '#{socks_proxy}'. Expected format is 'host:port'."
    end

    validate_dns_resolution(proxy_host)
    port = validate_port(proxy_port)

    [proxy_host, port]
  end

  # Checks if the hostname is resolvable.
  def validate_dns_resolution(host)
    Socket.getaddrinfo(host, nil)
  rescue SocketError => e
    raise Train::ClientError, "DNS resolution failed for SOCKS proxy host '#{host}': #{e.message}"
  end

  # Ensures port is a valid integer in range.
  def validate_port(port_str)
    port = Integer(port_str)
    unless port.between?(1, 65535)
      raise Train::ClientError, "SOCKS proxy port '#{port}' is out of valid range (1-65535)."
    end

    port
  rescue ArgumentError
    raise Train::ClientError, "Invalid SOCKS proxy port '#{port_str}'. Port must be an integer."
  end

  # Applies the validated proxy settings to TCPSocket.
  def configure_socks
    TCPSocket.socks_server = proxy_host
    TCPSocket.socks_port   = proxy_port
  end

  # Patches HTTPClient to route all connections through the SOCKS proxy.
  def patch_http_client
    HTTPClient::Session.class_eval do
      unless method_defined?(:original_create_socket)
        alias_method :original_create_socket, :create_socket

        # Override the `create_socket` method to use `TCPSocket` with SOCKS proxy.
        def create_socket(host, port, *args)
          socket = ::TCPSocket.new(host, port)
          socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, [5, 0].pack("l_2"))
          socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, [5, 0].pack("l_2"))
          socket
        rescue HTTPClient::ConnectTimeoutError
          raise Train::ClientError, "SOCKS proxy connection to #{host}:#{port} timed out (HTTPClient::ConnectTimeoutError)"
        rescue Errno::ETIMEDOUT
          raise Train::ClientError, "Connection to #{host}:#{port} timed out through SOCKS proxy."
        rescue Errno::EHOSTUNREACH, Errno::ENETUNREACH
          raise Train::ClientError, "Network unreachable when connecting to #{host}:#{port} via SOCKS proxy."
        rescue Errno::ECONNREFUSED
          raise Train::ClientError, "Connection refused by SOCKS proxy when connecting to #{host}:#{port}."
        rescue SocketError => e
          raise Train::ClientError, "Socket error while connecting to #{host}:#{port} via SOCKS proxy: #{e.message}"
        rescue StandardError => e
          raise Train::ClientError, "Unexpected error during SOCKS proxy connection: #{e.class} - #{e.message}"
        end
      end
    end
  end
end
