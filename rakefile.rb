unless $disable_tests
  require 'simplecov'
  require 'rake/testtask'

  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*_test.rb']
    t.verbose = true
  end

  desc "Run Tests"
  task :default => :test
end