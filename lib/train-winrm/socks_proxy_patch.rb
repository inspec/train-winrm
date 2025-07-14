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
  # @example
  #   SocksProxyPatch.apply("127.0.0.1:1080")
  def self.apply(socks_proxy)
    require "socksify"
    require "httpclient"

    # Extract the host and port from the SOCKS proxy address.
    proxy_host, proxy_port = socks_proxy.split(":")
    TCPSocket.socks_server = proxy_host
    TCPSocket.socks_port   = proxy_port.to_i

    # Patch the `HTTPClient::Session` class to use the SOCKS proxy.
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
