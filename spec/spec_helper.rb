$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cliclac'
require 'spec'
require 'spec/autorun'
require 'rack/test'

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end