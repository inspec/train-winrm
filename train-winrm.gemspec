# As plugins are usually packaged and distributed as a RubyGem,
# we have to provide a .gemspec file, which controls the gembuild
# and publish process.  This is a fairly generic gemspec.

# It is traditional in a gemspec to dynamically load the current version
# from a file in the source tree.  The next three lines make that happen.
lib = File.expand_path("../lib", __FILE__) # rubocop:disable Style/ExpandPathArguments
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "train-winrm/version"

Gem::Specification.new do |spec|
  # Importantly, all Train plugins must be prefixed with `train-`
  spec.name = "train-winrm"

  # It is polite to namespace your plugin under InspecPlugins::YourPluginInCamelCase
  spec.version       = TrainPlugins::WinRM::VERSION
  spec.authors       = ["Chef InSpec Team"]
  spec.email         = ["inspec@chef.io"]
  spec.summary       = "Windows WinRM API Transport for Train"
  spec.description   = "Allows applictaions using Train to speak to Windows using Remote Management; handles authentication, cacheing, and SDK dependency management."
  spec.homepage      = "https://github.com/inspec/train-winrm"
  spec.license       = "Apache-2.0"

  # Though complicated-looking, this is pretty standard for a gemspec.
  # It just filters what will actually be packaged in the gem (leaving
  # out tests, etc)
  spec.require_paths = ["lib"]
  spec.files = %w{LICENSE} + Dir.glob("lib/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }

  # If you rely on any other gems, list them here with any constraints.
  # This is how `inspec plugin install` is able to manage your dependencies.

  # If you only need certain gems during development or testing, list
  # them in Gemfile, not here.

  # Do not list inspec as a dependency of a train plugin.
  # Do not list train or train-core as a dependency of a train plugin.
  spec.add_dependency "chef-winrm", "~> 2.3.12" # This version is required to support Ruby 3.0
  spec.add_dependency "chef-winrm-elevated", "~> 1.2.5"
  spec.add_dependency "chef-winrm-fs", "~> 1.4.0" # This version supports Ruby 3.4

  # Gem dependency needed with Ruby 3.4 upgrade
  spec.add_dependency "syslog", "~> 0.1"
end
