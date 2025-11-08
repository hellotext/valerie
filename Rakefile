require 'rake/testtask'

Rake::TestTask.new do |task|
  task.pattern = 'test/**/*_test.rb'
end

desc 'Run tests'
task default: :test

# YARD documentation task
begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files = ['lib/**/*.rb']
    t.options = ['--markup', 'markdown', '--title', 'Valerie Documentation']
  end

  desc 'Generate YARD documentation and open in browser'
  task :doc => :yard do
    puts "Documentation generated in doc/"
    puts "Run 'open doc/index.html' to view"
  end
rescue LoadError
  # YARD not available
  desc 'Generate YARD documentation (YARD not installed)'
  task :yard do
    puts "YARD is not available. Install it with: gem install yard"
  end

  task :doc => :yard
end
