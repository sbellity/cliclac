module Cliclac
  class Key
    
    attr_reader :string, :object_id, :integer, :object, :original_key
    
    def self.escape(k)
      k.to_s.gsub("\"", "")
    end
    
    def initialize(key, prefer_original_type=false)
      @prefer_original_type = prefer_original_type
      if key.nil?
        @nil = true
      else
        @nil = false
        @original_key = key
        @escaped_key = Cliclac::Key.escape(key)
        @string = @escaped_key
        @object_id = Mongo::ObjectID.legal?(@escaped_key.to_s) ? Mongo::ObjectID.from_string(@escaped_key.to_s) : nil
        @integer = @escaped_key =~ /^[0-9]+$/ ? @escaped_key.to_i : nil
        @object = Yajl::Parser.new.parse(@original_key.to_s) rescue nil
      end
    end
    
    def nil?
      @nil
    end
    
    def design?
      not [false, nil].include?(@string =~ /^_design.*/)
    end
    
    def probable_value
      if @prefer_original_type && object_id.nil?
        original_key
      else
        object_id || integer || object || string
      end
    end
    
    def possible_values
      if (@original_key.to_s.length == 24 && !integer.nil?) || @original_key.is_a?(Integer)
        [integer, object_id, string, object].compact.uniq
      elsif object.is_a?(Hash) || object.is_a?(Array)
        [object, string].compact.uniq
      else
        [object_id, integer, string, object].compact.uniq
      end
    end
    
  end
end