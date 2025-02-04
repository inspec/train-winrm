source "https://rubygems.org"

# This is a Gemfile, which is used by bundler
# to ensure a coherent set of gems is installed.
# This file lists dependencies needed when outside
# of a gem (the gemspec lists deps for gem deployment)

# Bundler should refer to the gemspec for any dependencies.
gemspec

gem 'chef-winrm', git: 'https://github.com/chef/chef-winrm.git', branch: 'jfm/chef-winrm-update'
gem 'chef-winrm-fs', git: 'https://github.com/chef/chef-winrm-fs.git', branch: 'jfm/winrm-fs-update-2'
gem 'chef-winrm-elevated', git: 'https://github.com/chef/chef-winrm-elevated.git', branch: 'jfm/chef-winrm-elevated-update'

# Remaining group is only used for development.
group :development do
  # Depend on this here, not in the gemspec - to avoid having to have
  # client applications induce circular dependencies
  gem "train-core", "~> 3.0"
  gem "bundler"
  gem "byebug"
  gem "m"
  gem "minitest"
  gem "mocha"
  gem "pry"
  gem "rake"
  gem "chefstyle"
  # gem "chef-winrm-elevated"
end
