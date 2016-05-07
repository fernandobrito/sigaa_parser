require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

RSpec::Core::RakeTask.new('spec:ci') do |task|
  task.rspec_opts = ['--color', '--format', 'documentation', '--tag', '~headless']
end

task :default => :spec
