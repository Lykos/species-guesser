require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'

SPEC_FILES = 'spec/**/*_spec.rb'
SOURCE_FILES = 'lib/**/*.rb'
README = 'README.md'
RDOC_DIR = 'doc'

desc "Run all specs with RCov."
RSpec::Core::RakeTask.new('spec_with_rcov') do |t|
  t.pattern = SPEC_FILES
  t.rcov = true
  t.rcov_opts = ['--exclude', 'test', '--threshold', '100', '--text-summary', '--include', SOURCE_FILES]
end

desc "Run all specs without RCov."
RSpec::Core::RakeTask.new('default') do |t|
  t.pattern = SPEC_FILES
end

desc "Run all specs without RCov."
RSpec::Core::RakeTask.new('spec_show') do |t|
  t.rspec_opts = ['--format', 'documentation']
  t.pattern = SPEC_FILES
end

desc "Run RDoc on all source files."
RDoc::Task.new('rdoc') do |t|
  t.rdoc_dir = RDOC_DIR
  t.main = README
  t.rdoc_files.include(README, SOURCE_FILES)
end
