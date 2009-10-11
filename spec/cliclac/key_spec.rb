require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Cliclac::Key" do
  it "should be all nil if key.nil?" do
    key = Cliclac::Key.new(nil)
    key.nil?.should be_true
    key.string.should be_nil
    key.integer.should be_nil
    key.object_id.should be_nil
    key.object.should be_nil
  end

  it "should recognize legal MongoDB::ObjectIDs represented as string" do
    oid = Mongo::ObjectID.from_string("0123456789abcd0123456789")
    key = Cliclac::Key.new oid.to_s
    key.nil?.should_not be_true
    key.string.should == oid.to_s
    key.integer.should be_nil
    key.object_id.should be_instance_of(Mongo::ObjectID)
    key.object.should be_nil
    key.probable_value.should == oid
    key.possible_values.should == [key.object_id, key.string]
  end
  
  it "should recognize integers strings" do
    k = "123"
    key = Cliclac::Key.new k
    key.string.should == k
    key.integer.should == k.to_i
    key.object_id.should be_nil
    key.probable_value.should == key.integer
    key.possible_values.should == [key.integer, key.string]
  end
  
  it "should recognize json objects" do
    o = { "a" => "A" }
    k = Yajl::Encoder.new.encode(o)
    key = Cliclac::Key.new(k)
    escaped = Cliclac::Key.escape(k)
    key.string.should == escaped
    key.object.should == o
    key.object_id.should be_nil
    key.integer.should be_nil
    key.probable_value.should == o
    key.possible_values.should == [o,escaped]
  end
  
  it "should default to string as probable value" do
    o = "1234567febba1234567febbz"
    key = Cliclac::Key.new(o)
    key.integer.should be_nil
    key.object_id.should be_nil
    key.object.should be_nil
    key.string.should == o
    key.probable_value.should == o
    key.possible_values.should == [o]
  end
  
  it "should recognize design_keys" do
    Cliclac::Key.new("blabla").design?.should be_false
    Cliclac::Key.new(nil).design?.should be_false
    Cliclac::Key.new("_design.").design?.should be_true
  end
  
  it "should escape properly the keys" do
    Cliclac::Key.new("\"a\"").string.should == "a"
  end
  
end
