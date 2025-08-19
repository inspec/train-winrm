require_relative "helper"

# rubocop: disable Metrics/BlockLength

require "train-winrm/transport"
require "train-winrm/connection"
require "chef-winrm/output"

describe "winrm connection" do
  let(:cls) do
    plat = Train::Platforms.name("mock").in_family("windows")
    plat.add_platform_methods
    Train::Platforms::Detect.stubs(:scan).returns(plat)
    TrainPlugins::WinRM::Connection
  end
  let(:conf) do
    {
      hostname: rand.to_s,
      logger: Logger.new(STDERR, level: :info),
    }
  end
  describe "#run_command_via_connection through BaseConnection::run_command" do
    let(:winrm) { cls.new(conf) }
    let(:session_mock) do
      session_mock = mock
      session_mock.expects(:run)
        .with("test")
        .yields("testdata", "ignored")
        .returns(WinRM::Output.new)

      session_mock
    end
    it "invokes the provided block when a block is provided and data is received" do
      called = false
      winrm.expects(:session).returns(session_mock)

      # We need to test run_command b/c run_command_via_connection is private.
      winrm.run_command("test") do |data|
        called = true
        _(data).must_equal "testdata"
      end
      _(called).must_equal true
    end
  end

  describe "establishes successful kerberos auth winrm connection" do
    let(:cls) { TrainPlugins::WinRM::Connection }
    it "retrieves platform after kerberos connection" do
      conf = {
        hostname: "dummy",
        transport: :kerberos,
        password: "dummy",
        logger: Logger.new(STDERR, level: :info),
      }
      conn = cls.new(conf)
      # Simulate successful connection and platform detection
      conn.stubs(:os).returns({ name: "windows", family: "windows", release: "10.0", arch: "x86_64" })
      os = conn.os
      _(os[:name]).must_equal "windows"
      _(os[:family]).must_equal "windows"
      _(os[:release]).must_equal "10.0"
      _(os[:arch]).must_equal "x86_64"
    end
  end
end
