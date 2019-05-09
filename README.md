# train-winrm - Train Plugin for connecting to Windows via Remote Management

This plugin allows applications that rely on Train to communicate with the WinRM API.  For example, you could use this to audit Windows Server 2016 machines.

This plugin relies on the `winrm` and `winrm-fs` gems for implementation.

Train itself has no CLI, nor a sophisticated test harness.  Chef InSpec does have such facilities, so installing Train plugins will require a Chef InSpec installation.  You do not need to use or understand Chef InSpec.

Train plugins may be developed without a Chef InSpec installation.

## To Install this as a User

### ChefDK Installation

After June 2019, this plugin will be distributed with ChefDK; you do not need to install it separately.

### Manual Installation

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
transport = Train.create('winrm',
  host: '1.2.3.4', user: 'Administrator', password: '...', ssl: true, self_signed: true)
conn = transport.connection
```

## Target Options for Train-WinRM

### host

Required `String`. The hostname or IP address to connect to.

#### port

Optional `Integer`, default 5985 (plain) or 5896 (SSL). The port number to which the connection should be made.

### user

Optional `String`, username to connect as.  Default 'Administrator'.

### password

Optional `String`, password to use to connect. None sent if not provided.

### ssl

Optional `Boolean`, defaults to `false`. Whether to use SSL to encrypt communications.

Several other options exist; run:

```
puts Train.options('winrm')
```

## Reporting Issues

Bugs, typos, limitations, and frustrations are welcome to be reported through the [GitHub issues page for the train-winrm project](https://github.com/inspec/train-winrm/issues).

You may also ask questions in the #inspec channel of the Chef Community Slack team.  However, for an issue to get traction, please report it as a github issue.

## Development on this Plugin

### Development Process

If you wish to contribute to this plugin, please use the usual fork-branch-push-PR cycle.  All functional changes need new tests, and bugfixes are expected to include a new test that demonstrates the bug.

### Reference Information

[Plugin Development](https://github.com/inspec/train/blob/master/docs/dev/plugins.md) is documented on the `train` project on GitHub.

### Testing changes against a Windows Machine

TODO