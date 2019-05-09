# A Rakefile defines tasks to help maintain your project.
# Rake provides several task templates that are useful.

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
  Rake::TestTask.new(:unit) do |t|
    t.libs.push 'lib'
    t.libs.push 'test'
    t.test_files = FileList['test/unit/*_test.rb']
    t.verbose = false
    t.warning = false
  end

  task :start_vagrant do |t|
    # The Vagrantfile relies on a vagrant box that is private to Chef
    # Consider https://app.vagrantup.com/peru/boxes/windows-server-2016-standard-x64-eval as alternative
    sh 'vagrant up'
  end

  task :integration_actual do |t|
    # TODO Read vars from vagrant?
    env = ''
    env +="TRAIN_WINRM_TARGET=winrm://vagrant@127.0.0.1 "
    env +="TRAIN_WINRM_PASSWORD=vagrant "

    Dir.glob('test/integration/*_test.rb').all? do |file|
      sh "#{env} #{Gem.ruby} -I ./test/integration #{file}"
    end or fail 'Failures'
  end

  task :stop_vagrant do |t|
    sh 'vagrant destroy --force'
  end

  desc 'Integration tasks, Vagrant+VirtualBox-based'
  task :integration => [:start_vagrant, :integration_actual, :stop_vagrant]

end

# #------------------------------------------------------------------#
# #                    Code Style Tasks
# #------------------------------------------------------------------#
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:lint) do |t|
  # Choices of rubocop rules to enforce are deeply personal.
  # Here, we set things up so that your plugin will use the Bundler-installed
  # train gem's copy of the Train project's rubocop.yml file (which
  # is indeed packaged with the train gem).
  if File.exist?('../train/.rubocop.yml')
    train_rubocop_yml = '../train/.rubocop.yml'
  else
    require 'train/globals'
    train_rubocop_yml = File.join(Train.src_root, '.rubocop.yml')
  end

  t.options = ['--display-cop-names', '--config', train_rubocop_yml]
end
