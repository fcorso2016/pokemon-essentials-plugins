require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "Tests"
  t.test_files = FileList['Tests/**/*_test.rb']
  t.verbose = true
end

task :default => :test