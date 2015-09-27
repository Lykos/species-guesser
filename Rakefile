require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'

SPEC_FILES = 'spec/**/*_spec.rb'
SOURCE_FILES = 'lib/**/*.rb'
README = 'README.md'
RDOC_DIR = 'doc'

desc "Run all specs."
RSpec::Core::RakeTask.new('default') do |t|
  t.rspec_opts = ['--format', 'documentation']
  t.pattern = SPEC_FILES
end

desc "Run RDoc on all source files."
RDoc::Task.new('rdoc') do |t|
  t.rdoc_dir = RDOC_DIR
  t.main = README
  t.rdoc_files.include(README, SOURCE_FILES)
end
