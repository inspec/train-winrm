# frozen_string_literal: true
require "socksify"
require "socksify/socket"

module TrainPlugins
  module WinRM
    module SocksProxyPatch
      def self.apply!
        return if @patched

        TCPSocket.singleton_class.class_eval do
          alias_method :original_open, :open

          def open(remote_host, remote_port, *args)
            if ENV["SOCKS5_PROXY"]
              proxy_host, proxy_port = ENV["SOCKS5_PROXY"].split(":")
              SOCKSSocket.new(remote_host, remote_port, proxy_host, proxy_port.to_i)
            else
              original_open(remote_host, remote_port, *args)
            end
          end
        end

        @patched = true
      end
    end
  end
end



