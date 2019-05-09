# encoding: utf-8

# rubocop: disable Metrics/BlockLength

# author: Christoph Hartmann
# author: Dominik Richter

require 'minitest/autorun'
require 'train'
require 'train'
require 'byebug'
require 'logger'

describe 'windows winrm command' do
  let(:conn) {
    logger = Logger.new(STDERR, level: (ENV['TRAIN_WINRM_LOGLEVEL'] || :info))

    # get final config
    target_config = Train.target_config({
                                          target: ENV['TRAIN_WINRM_TARGET'],
      password: ENV['TRAIN_WINRM_PASSWORD'],
      ssl: ENV['TRAIN_WINRM_SSL'],
      self_signed: true,
      logger: logger,
                                        })

    # initialize train
    backend = Train.create('winrm', target_config)

    # start or reuse a connection
    conn = backend.connection
    conn
  }

  it 'verify os' do
    os = conn.os
    os[:name].must_equal 'windows_server_2016_standard_evaluation'
    os[:family].must_equal 'windows'
    os[:release].must_equal '10.0.14393'
    os[:arch].must_equal 'x86_64'
  end

  it 'run echo test' do
    cmd = conn.run_command('Write-Output "test"')
    cmd.stdout.must_equal "test\r\n"
    cmd.stderr.must_equal ''
  end

  it 'use powershell piping' do
    cmd = conn.run_command("New-Object -Type PSObject | Add-Member -MemberType NoteProperty -Name A -Value (Write-Output 'PropertyA') -PassThru | Add-Member -MemberType NoteProperty -Name B -Value (Write-Output 'PropertyB') -PassThru | ConvertTo-Json")
    cmd.stdout.must_equal "{\r\n    \"A\":  \"PropertyA\",\r\n    \"B\":  \"PropertyB\"\r\n}\r\n"
    cmd.stderr.must_equal ''
  end

  describe 'using remote files' do
    before do
      @remote_path = 'train-winrm-test-' + rand(100000).to_s + '.txt'
    end

    let(:remote_file) do
      conn.run_command("New-Item -Path . -Name \"#{@remote_path}\" -ItemType \"file\" -Value \"hello world\"")
      conn.file(@remote_path)
    end

    it 'exists' do
      remote_file.exist?.must_equal(true)
    end

    it 'is a file' do
      remote_file.file?.must_equal(true)
    end

    it 'has type :file' do
      remote_file.type.must_equal(:file)
    end

    it 'has content' do
      # TODO: this shouldn't include newlines that aren't in the original file
      remote_file.content.must_equal("hello world\r\n")
    end

    it 'has owner name' do
      remote_file.owner.wont_be_nil
    end

    it 'has no group name' do
      remote_file.group.must_be_nil
    end

    it 'has no mode' do
      remote_file.mode.must_be_nil
    end

    it 'has no modified time' do
      remote_file.mtime.must_be_nil
    end

    it 'has size' do
      remote_file.size.wont_be_nil
    end

    it 'has size 11' do
      remote_file.size.must_equal 11
    end

    it 'has no selinux_label handling' do
      remote_file.selinux_label.must_be_nil
    end

    it 'has product_version' do
      remote_file.product_version.wont_be_nil
    end

    # TODO: This is not failing in manual testing
    # it 'returns basname of file' do
    #   basename = ::File.basename(@local_file)
    #   remote_file.basename.must_equal basename
    # end

    it 'has file_version' do
      remote_file.file_version.wont_be_nil
    end

    it 'returns nil for mounted' do
      remote_file.mounted.must_be_nil
    end

    it 'has no link_path' do
      remote_file.link_path.must_be_nil
    end

    it 'has no uid' do
      remote_file.uid.must_be_nil
    end

    it 'has no gid' do
      remote_file.gid.must_be_nil
    end

    it 'provides a json representation' do
      j = remote_file.to_json
      j.must_be_kind_of Hash
      j['type'].must_equal :file
    end

    after do
      conn.run_command("Remove-Item -Path \"#{@remote_path}\"")
    end
  end

  describe 'hashing methods' do
    before do
      @remote_path = 'train-winrm-hash-test-' + rand(100000).to_s + '.txt'
    end

    let(:remote_file) do
      conn.run_command("New-Item -Path . -Name \"#{@remote_path}\" -ItemType \"file\" -Value \"easy to hash\"")
      conn.file(@remote_path)
    end

    it 'has the correct md5sum' do
      remote_file.md5sum.must_equal 'c15b41ade1221a532a38d89671ffaa20'
    end

    it 'has the correct sha256sum' do
      remote_file.sha256sum.must_equal '24ae25354d5f697566e715cd46e1df2f490d0b8367c21447962dbf03bf7225ba'
    end

    after do
      conn.run_command("Remove-Item -Path \"#{@remote_path}\"")
    end
  end

  describe 'a file with whitespace in the path' do
    before do
      # This is just being used to generate a randomized path
      @local_file = Tempfile.new('foo bar')
    end

    let(:remote_file) { conn.file(@local_file.path) }

    it 'provides the full path with whitespace' do
      # No implication that it exists
      remote_file.path.must_equal @local_file.path
    end

    after do
      @local_file.close
      @local_file.unlink
    end
  end

  after do
    # close the connection
    conn.close
  end
end
