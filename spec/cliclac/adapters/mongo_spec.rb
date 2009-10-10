require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

Cliclac.adapter = Cliclac::Adapters::Mongo.new()

def separator
  Cliclac.adapter.options[:separator]
end

describe Cliclac::Adapters::Mongo do
  
  def init_dbs
    @a = Cliclac.adapter
    @db_names = ["test_db___1_lqwiuelqwieub", "test_db___2_lakshdfsasiuh"]
    @col_names = ["test_collection", "test2_askjdfhs"]
    @dbs = @db_names.inject({}) { |dbs, dbn| dbs.merge(dbn => Cliclac.adapter.connection.db(dbn)) }
    @dbs.map do |dbn, db| 
      @col_names.map { |col| db.collection(col).insert({ "test" => "Test #{rand(1000)}" }) }
      db.collection("__design").insert({ "map" => "function() { ... }", "reduce" => "function() { ... }" })
    end
  end
  
  def clear_dbs
    @db_names.map { |dbn| Cliclac.adapter.connection.drop_database(dbn) }
  end
  
  def db_name(d,c,sep=nil)
    [d,c].join(separator)
  end
  
  context "on list databases" do 
    
    before(:all) { init_dbs }
    
    after(:all) { clear_dbs }
    
    it "should list known databases and filter system and __design collections" do
      dbs = @a.database_names
      dbs.should include(db_name(@db_names[0], "test_collection"))
      dbs.should include(db_name(@db_names[1], "test_collection"))
      dbs.should_not include(db_name(@db_names[1], "system.indexes"))
      dbs.should_not include(db_name(@db_names[1], "__design"))
    end
    
    it "should filter collection on name given" do
      dbs = @a.database_names(@col_names[0])
      dbs.should include(db_name(@db_names[0], @col_names[0]))
      dbs.should_not include(db_name(@db_names[0], @col_names[1]))
    end
    
    it "should include system collections if told to" do
      dbs = @a.database_names("", :include_system => true)
      dbs.should include(db_name(@db_names[0], "system.indexes"))
      dbs.should_not include(db_name(@db_names[0], "__design"))
    end
    
    it "should include __design collection if told to" do
      dbs = @a.database_names("", :include_design => true)
      dbs.should include(db_name(@db_names[0], "__design"))
      dbs.should_not include(db_name(@db_names[0], "system.indexes"))
    end
    
  end
  
  
end