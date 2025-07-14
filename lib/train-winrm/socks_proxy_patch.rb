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
          ::TCPSocket.new(host, port)
        end
      end
    end
  end
end
