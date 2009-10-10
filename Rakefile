require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cliclac"
    gem.summary = %Q{A port of CouchDB's Futon web interface to MongoDB}
    gem.description = %Q{A port of CouchDB's Futon web interface to MongoDB. For more information, see http://www.github.com/sbellity/cliclac}
    gem.email = "sbellity@gmail.com"
    gem.homepage = "http://github.com/sbellity/cliclac"
    gem.authors = ["Stephane Bellity"]
    gem.rubyforge_project = "cliclac"
    gem.add_dependency "mongo", ">= 0.15"
    gem.add_dependency "mongo_ext", ">= 0.15"
    gem.add_dependency "sinatra", ">= 0.9.4"
    gem.add_dependency "yajl-ruby", ">= 0.6.3"
    gem.add_development_dependency "rspec", ">= 1.2.8"
    gem.add_development_dependency "rack-test", ">= 0.5.0"
    gem.default_executable = %{cliclac}
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
  # Jeweler::RubyforgeTasks.new do |rubyforge|
  #   rubyforge.doc_task = "rdoc"
  # end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cliclac #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
