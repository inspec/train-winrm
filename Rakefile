# A Rakefile defines tasks to help maintain your project.
# Rake provides several task templates that are useful.

#------------------------------------------------------------------#
#                    Rake Default Task
#------------------------------------------------------------------#

# Do not run integration by default
task default: %i{lint test:unit test:functional}

#------------------------------------------------------------------#
#                    Test Runner Tasks
#------------------------------------------------------------------#
require "rake/testtask"

task test: "test:unit"

namespace :test do
  {
    unit: "test/unit/*_test.rb",
    integration: "test/integration/*_test.rb",
    functional: "test/functional/*_test.rb",
  }.each do |task_name, glob|
    Rake::TestTask.new(task_name) do |t|
      t.libs.push "lib"
      t.libs.push "test"
      t.test_files = FileList[glob]
      t.verbose = true
      t.warning = false
    end
  end

  task :start_vagrant do |_t|
    # The Vagrantfile relies on a vagrant box that is private to Chef
    # Consider https://app.vagrantup.com/peru/boxes/windows-server-2016-standard-x64-eval as alternative
    sh "vagrant up"
  end

  task :integration_actual do |_t|
    # TODO: Read vars from vagrant?
    env = ""
    env += "TRAIN_WINRM_TARGET=winrm://vagrant@127.0.0.1 "
    env += "TRAIN_WINRM_PASSWORD=vagrant "

    %w{powershell elevated}.each do |shell_type|
      env += "TRAIN_WINRM_SHELL_TYPE=#{shell_type} "
      Dir.glob("test/integration/*_test.rb").all? do |file|
        sh "#{env} #{Gem.ruby} -I ./test/integration #{file}"
      end || raise("Failures")
    end
  end

  task :stop_vagrant do |_t|
    sh "vagrant destroy --force"
  end

  desc "Integration tasks, Vagrant+VirtualBox-based"
  task integration: %i{start_vagrant integration_actual stop_vagrant}

end

# #------------------------------------------------------------------#
# #                    Code Style Tasks
# #------------------------------------------------------------------#
require "cookstyle/chefstyle"
require "rubocop/rake_task"

RuboCop::RakeTask.new(:lint) do |task|
  task.options << "--display-cop-names"
end
