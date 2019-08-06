# A Rakefile defines tasks to help maintain your project.
# Rake provides several task templates that are useful.

require "chefstyle"
require "rubocop/rake_task"

#------------------------------------------------------------------#
#                    Rake Default Task
#------------------------------------------------------------------#

# Do not run integration by default
task default: %i(test:unit test:functional)

#------------------------------------------------------------------#
#                    Test Runner Tasks
#------------------------------------------------------------------#
require 'rake/testtask'

namespace :test do
  desc 'Run ChefStyle Linting'
  RuboCop::RakeTask.new(:lint)

  {
    unit: 'test/unit/*_test.rb',
    integration: 'test/integration/*_test.rb',
    functional: 'test/functional/*_test.rb',
  }.each do |task_name, glob|
    Rake::TestTask.new(task_name) do |t|
      t.libs.push 'lib'
      t.libs.push 'test'
      t.test_files = FileList[glob]
      t.verbose = true
      t.warning = false
    end
  end

end