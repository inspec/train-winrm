# test/unit/socks_proxy_patch_test.rb
require_relative "helper"
require "socket"
require "httpclient"
require "socksify"
require_relative "../../lib/train-winrm/socks_proxy_patch"

class SocksProxyPatchTest < Minitest::Test
  def test_applies_patch_with_valid_proxy
    Socket.stubs(:getaddrinfo).returns([["AF_INET", "127.0.0.1", "localhost", "127.0.0.1"]])
    assert_silent do
      SocksProxyPatch.apply(socks_proxy: "127.0.0.1:1080")
    end
  end

  def test_rejects_invalid_proxy_format
    error = assert_raises(Train::ClientError) do
      SocksProxyPatch.apply(socks_proxy: "invalid_format")
    end
    assert_match(/Invalid SOCKS proxy format/, error.message)
  end

  def test_rejects_invalid_port
    error = assert_raises(Train::ClientError) do
      SocksProxyPatch.apply(socks_proxy: "localhost:abc")
    end
    assert_match(/Port must be an integer/, error.message)
  end

  def test_rejects_unresolvable_host
    Socket.stubs(:getaddrinfo).raises(SocketError, "no address for bad.host")
    error = assert_raises(Train::ClientError) do
      SocksProxyPatch.apply(socks_proxy: "bad.host:1080")
    end
    assert_match(/DNS resolution failed/, error.message)
  end
end
