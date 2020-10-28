require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task :run do
  system("ruby copy_files.rb")
  Dir["#{Dir.pwd}/lib/**/*.etl"].each { |f| system("kiba #{f}") }
  system("ruby merge_csv.rb")
end
