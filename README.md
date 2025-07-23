# train-winrm - Train Plugin for connecting to Windows via Remote Management

[![Gem Version](https://badge.fury.io/rb/train-winrm.svg)](https://badge.fury.io/rb/train-winrm)
[![Build status](https://badge.buildkite.com/f293066ffe281ec41dc14fe941a2bafbdfa8110c0cd4024c88.svg?branch=master)](https://buildkite.com/chef-oss/inspec-train-winrm-master-verify)

* **Project State: Active**
* **Issues Response SLA: 3 business days**
* **Pull Request Response SLA: 3 business days**

This plugin allows applications that rely on Train to communicate with the WinRM API.  For example, you could use this to audit Windows Server 2016 machines.

This plugin relies on the `chef-winrm` and `chef-winrm-fs` gems for implementation.

Train itself has no CLI, nor a sophisticated test harness.  Chef InSpec does have such facilities, so installing Train plugins will require a Chef InSpec installation.  You do not need to use or understand Chef InSpec.

Train plugins may be developed without a Chef InSpec installation.

## To Install this as a User

### ChefDK Installation

After August 2019, this plugin will be distributed with ChefDK; you do not need to install it separately.

### Manual Installation using `inspec plugin install`

Train plugins are distributed as gems.  You may choose to manage the gem yourself, but if you are an Chef InSpec user, Chef InSpec can handle it for you.

You will need Chef InSpec v2.3 or later.

Simply run:

```
$ inspec plugin install train-winrm
```

You can then run, using Chef InSpec as an example:

```
you@home $ inspec some-profile winrm://someuser@somehost --password somepassword
```

From Ruby code, you may use this plugin as follows:
```
require 'train'
transport = Train.create(
  'winrm',
  host: '1.2.3.4',
  user: 'Administrator',
  password: '...',
  ssl: true,
  self_signed: true
)
conn = transport.connection
```

## Target Options for Train-WinRM

### host

Required `String`. The hostname or IP address used for connection.

#### port

Optional `Integer`, default 5985 (plain) or 5896 (SSL). The port number to which the connection should be made.

### user

Optional `String`, username used for sign in.  Default `Administrator`.

### password

Optional `String`, password used for sign in. None sent if not provided.

### ssl

Optional `Boolean`. Defaults to `false`. Determines whether to use SSL to encrypt communications.

### kerberos_realm

Optional `String`. Specifies the Kerberos realm (e.g., `INSPEC.DEV`). Required if using `kerberos` transport.

### kerberos_service

Optional `String`. The SPN service name, such as `host`.

### winrm_transport

Optional `String`. Can be `negotiate`, `ssl`, `plaintext`, `kerberos`. Set to `kerberos` to use Kerberos authentication.

### socks_proxy

Optional `String`. SOCKS5H proxy in format `host:port`, e.g., `localhost:1080`. Useful when tunneling WinRM over a SOCKS5 proxy.

**Note:** Only SOCKS5H proxies are supported. HTTP proxies or chained proxies are not currently supported.

### socks_user

Optional `String`. Username for SOCKS proxy authentication.

### socks_password

Optional `String`. Password for SOCKS proxy authentication.

Several other options exist. To see these options, run:

```
puts Train.options('winrm')
```

### Example CLI usage with Kerberos and SOCKS5 proxy:

```shell
inspec exec https://github.com/dev-sec/windows-patch-baseline -t winrm://user01@win-dc-01.inspec.dev \
  --password 'XXXXXXX \
  --kerberos_service host \
  --kerberos_realm INSPEC.DEV \
  --winrm_transport kerberos \
  --socks_proxy localhost:1080
```

### Ruby usage with SOCKS5H and Kerberos:

```ruby
require 'train'
transport = Train.create(
  'winrm',
  host: 'win-dc-01.inspec.dev',
  user: 'user01',
  password: 'XXXXXXX,
  winrm_transport: 'kerberos',
  kerberos_service: 'host',
  kerberos_realm: 'INSPEC.DEV',
  socks_proxy: 'localhost:1080',
  socks_user: 'my_socks_user',
  socks_password: 'my_socks_pass'
)
conn = transport.connection
```

## Troubleshooting SOCKS5H Proxy Connections

If you encounter issues when connecting through a SOCKS5H proxy:

- **DNS resolution failed**: Verify the proxy hostname is resolvable from the client machine.
- **Connection refused**: Confirm the proxy server is running and accessible on the provided port.
- **Authentication failures**: Double-check the `socks_user` and `socks_password` values.
- **Timeouts**: Ensure proper network routes exist and the firewall isn't blocking traffic.

Only SOCKS5H proxies are supported. HTTP or chained proxy types are not supported at this time.

## Reporting Issues

Bugs, typos, limitations, and frustrations are welcome to be reported through the [GitHub issues page for the train-winrm project](https://github.com/inspec/train-winrm/issues).

You may also ask questions in the #inspec channel of the Chef Community Slack team.  However, for an issue to get traction, please report it as a github issue.

## Development on this Plugin

### Development Process

If you wish to contribute to this plugin, please use the usual fork-branch-push-PR cycle.  All functional changes need new tests, and bugfixes are expected to include a new test that demonstrates the bug.

### Reference Information

[Plugin Development](https://github.com/inspec/train/blob/master/docs/dev/plugins.md) is documented on the `train` project on GitHub.

### Unit tests

Run `bundle exec rake test:unit` to run the unit tests.

### Testing changes against a Windows Machine

Install Vagrant and VirtualBox. Check the Vagrantfile to verify that it references a Windows 2016 evaluation VagrantBox to which you have access.

Then, run `bundle exec rake test:integration`. There are sub-tasks you can use to run only the integration tests; to see a list of all tasks, run `rake -aT`.
