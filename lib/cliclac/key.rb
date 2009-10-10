module Cliclac
  class Key
    
    attr_reader :string, :object_id, :integer, :object, :original_key
    
    def initialize(key, prefer_original_type=false)
      @prefer_original_type = prefer_original_type
      if key.nil?
        @nil = true
      else
        @nil = false
        @original_key = key
        key = key.gsub("\"", "")
        @string = key.to_s
        @object_id = Mongo::ObjectID.legal?(key.to_s) ? Mongo::ObjectID.from_string(key.to_s) : nil
        @integer = key =~ /^[0-9]+$/ ? key.to_i : nil
        @object = Yajl::Parser.new.parse(key.to_s) rescue nil
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