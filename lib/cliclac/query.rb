module Cliclac
  class Query
    attr_accessor :collection, :conditions, :options
    def initialize(*args)
      opts = args.extract_options!
      
      @options = {
        :limit => opts[:limit].nil? ? 10 : opts[:limit].to_i,
        :sort => opts[:sort] || { "_id" => (opts[:descending] == "true" ? -1 : 1) },
        :skip => opts[:skip] || 0
      }
      
      @collection = args[0]
      @conditions = args[1].is_a?(Hash) ? args[1] : {}
    end
    
    def run
      Cliclac.adapter.find(collection, conditions, options)
    end
    
  end
end