require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/models/*_test.rb"
  t.verbose = true
end