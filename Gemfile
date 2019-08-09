# encoding: utf-8

source "https://rubygems.org"

# This is a Gemfile, which is used by bundler
# to ensure a coherent set of gems is installed.
# This file lists dependencies needed when outside
# of a gem (the gemspec lists deps for gem deployment)

# Bundler should refer to the gemspec for any dependencies.
gemspec

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
end
