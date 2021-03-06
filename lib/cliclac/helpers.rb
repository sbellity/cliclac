module Cliclac
  module Helpers
    
    # Response
    include Rack::Utils
    
    def respond content="", status_code=200
      if @env["HTTP_ACCEPT"] =~ /json/
        content_type "application/json"
      else
        content_type "text/plain;charset=utf-8"
      end
      status status_code
      return "#{content.to_json}\n"
    end
    
    def ok status_code=200, h={}
      respond({ "ok" => true }.merge(h), status_code)
    end
    
    def error(type, msg, status_code=500)
      respond({:error => type, :reason => msg}, status_code)
    end

    def error_not_found
      error "not_found", "missing", 404
    end
    
    def location(d, doc_id=nil)
      "http://#{@env["HTTP_HOST"]}/#{db_name}#{"/#{doc_id}" unless doc_id.nil?}"
    end
    
    # Request
    
    def body
      @body_string ||= @request.body.read
      begin
        doc = Yajl::Parser.new.parse(@body_string)
        raise Cliclac::InvalidDocumentError if !doc.is_a?(Hash)
        doc
      rescue
        raise Cliclac::InvalidDocumentError
      end
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
      unescape params[:db]
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
      options[:sort] = [["_id", params[:descending] == "true" ? "descending" : "ascending"]]
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
        if include_docs_in_value
          d["value"] =  doc
        else 
          d["value"] =  doc.inject({}) do |r,c| 
            if c[1].is_a?(Hash) || c[1].is_a?(Array)
              v = '...'
            else
              v= c[1]
            end
            c[0] == "_id" ? r : r.merge(c[0] => v)
          end
        end
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