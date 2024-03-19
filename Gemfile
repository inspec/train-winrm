source "https://rubygems.org"

# This is a Gemfile, which is used by bundler
# to ensure a coherent set of gems is installed.
# This file lists dependencies needed when outside
# of a gem (the gemspec lists deps for gem deployment)

# Bundler should refer to the gemspec for any dependencies.
gemspec

if Gem.ruby_version.to_s.start_with?("2.5")
  # 16.7.23 required ruby 2.6+
  gem "chef-utils", "< 16.7.23" # TODO: remove when we drop ruby 2.5
end

# Remaining group is only used for development.
group :development do
  # Depend on this here, not in the gemspec - to avoid having to have
  # client applications induce circular dependencies
  gem "train-core", git: "https://github.com/inspec/train.git", branch: "bs/fix-CHEF-8031"
  gem "bundler"
  gem "byebug"
  gem "m"
  gem "minitest"
  gem "mocha"
  gem "pry"
  gem "rake"
  gem "chefstyle"
  gem "winrm-elevated"
end
