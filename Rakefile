require 'rake/testtask'

task default: [:spec]

desc 'Run specs'
task :spec do
  sh 'ruby -I lib spec/*_spec.rb'
end
