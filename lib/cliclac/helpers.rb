module Cliclac
  module Helpers
    
    # Response
    
    def respond content="", status_code=200
      content_type "application/json"
      status status_code
      return content.to_json
    end
    
    def ok status_code=200
      respond({ "ok" => true }, status_code)
    end
    
    def error_not_found
      respond({"error" => "not_found", "reason" => "missing" }, 404)
    end
    
    
    # Adapter
    def adapter
      Cliclac.adapter
    end
    
    def all_dbs
      adapter.database_names
    end
    
    def design_dbs
      adapter.database_names("/^__design$")
    end
    
    def system_dbs
      adapter.database_names("/^system\..+")
    end
    
    def conn
      Cliclac.connection
    end
    
    def db_name
      params[:db]
    end
    
    def db d=nil
      adapter.db(d || db_name)
    end
    
    def design_db d=nil
      adapter.design_db(d || db_name)
    end
    
    # params
    
    def query_options
      options = {}
      options[:limit] = params[:limit].nil? ? 10 : params[:limit].to_i
      options[:sort] = { "_id" => (params[:descending] == "true" ? -1 : 1) }
      options[:skip] = params[:skip].nil? ? 0 : params[:skip].to_i
      return options
    end
    
    def startkey
      @startkey || get_key(:startkey)
    end
    
    def endkey
      @endkey ||= get_key(:endkey)
    end
    
    def startkey_docid
      @startkey_docid ||= get_key(:startkey_docid)
    end
        
    # Results
    
    def list_documents res, include_docs=false, include_docs_in_value=false
      include_docs ||= ( params[:include_docs] == "true" )
      
      rows = res[:rows].map do |doc|
        d = { "id" => doc["_id"].to_s, "key" => doc["_id"].to_s }
        d["value"] = include_docs_in_value ? doc : doc.keys
        d["doc"] = doc if include_docs
        d
      end
      
      {
        "total_rows" => res[:total_rows],
        "offset" => res[:skip] || 0,
        "rows" => rows
       }.to_json
    end
    
    private
    
    def get_key(key_name)
      Cliclac::Key.new(params[key_name])
    end
    
  end
end