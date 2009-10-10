require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Cliclac::App do
  
  def app
    Cliclac::App
  end
  
  def adapter
    Cliclac.adapter
  end
  
  def json_response
    Yajl::Parser.new.parse(last_response.body)
  end
  
  context "Mongo Adapter" do
    
    before(:all) do
      Cliclac.adapter = Cliclac::Adapters::Mongo.new
      @test_db_name = "testdb_#{Time.now.to_i}"
    end
    
    after(:all) do
      Cliclac.adapter.connection.drop_database(@test_db_name)
    end
    
    it "should give db info on /" do
      get '/'
      last_response.should be_ok
      json_response.should == { adapter.db_type => "Welcome", "version" => adapter.db_version }
    end
    
    it "should list database names on /_all_dbs" do
      get '/_all_dbs'
      last_response.should be_ok
      json_response.should == adapter.database_names
    end
    
    it "should create a database on PUT /:db" do
      d = [@test_db_name, "testcol_#{Time.now.to_i}"].join(adapter.options[:separator])
      put "/#{d}/"
      last_response.status.should == 201
      json_response.should == { "ok" => true }
      put "/#{d}2"
      last_response.status.should == 201
    end
    
    it "should delete a database on DELETE /:db" do
      d = [@test_db_name, "testcol_to_delete_#{Time.now.to_i}"].join(adapter.options[:separator])
      adapter.create_db(d)
      adapter.database_names.should include(d)
      delete "/#{d}/"
      last_response.should be_ok
      adapter.database_names.should_not include(d)
    end
    
    it "does something" do
      
    end
    
  end
end