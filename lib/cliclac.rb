ROOT_PATH = File.expand_path(File.join(__FILE__, ".."))

$:.unshift("lib")

require "rubygems"
require "sinatra/base"
require "mongo"
require "net/http"
require "yajl"
require 'yajl/json_gem'
require "uri"
require "cgi"
require "singleton"

require "cliclac/utils"
require "cliclac/key"
require "cliclac/adapters/base"
require "cliclac/adapters/mongo"
require "cliclac/helpers"
require "cliclac/couchdb_compatibility"
require "cliclac/app"

require "pp"

module Cliclac
  
  class InvalidDocumentError < RuntimeError; end
  class OperationFailure < RuntimeError; end
  
  def self.adapter
    @@adapter ||= Cliclac::Adapters::Mongo.new
    @@adapter
  end
  
  def self.adapter=(a)
    @@adapter = a
  end
  
  def self.start(options={})
    @@adapter = Cliclac::Adapters::Mongo.new(options[:mongo])
    Cliclac::App.run!(options[:sinatra])
  end
  
end