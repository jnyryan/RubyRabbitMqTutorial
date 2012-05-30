require 'rake'
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
                                    # Put spec opts in a file named .rspec in root
  t.rspec_opts = ['--format nested']
end

task :default  => :spec