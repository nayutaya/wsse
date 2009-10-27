
require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = Dir.glob("test/**/*_test.rb")
  test.verbose    =  true
end

desc "Generate gemspec file from template"
task :gemspec do
  require "erb"
  require "lib/wsse/version"

  name = "nayutaya-wsse"
  src  = File.open("#{name}.gemspec.erb", "rb") { |file| file.read }
  erb  = ERB.new(src, nil, "-")

  version = Wsse::VERSION
  date    = Time.now.strftime("%Y-%m-%d")

  files = Dir.glob("**/*").
    select { |path| File.file?(path) }.
    reject { |path| /^nbproject\// =~ path }.
    sort

  test_files = Dir.glob("test/**.rb").
    select { |path| File.file?(path) }.
    sort

  File.open("#{name}.gemspec", "wb") { |file|
    file.write(erb.result(binding))
  }
end
