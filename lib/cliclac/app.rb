module Cliclac
  class App < Sinatra::Default
    
    include Cliclac::Helpers
    
    set :public, File.expand_path(ROOT_PATH + "/../public")
    disable :unescape_path
    
    # info
    get "/" do
      # if @env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
      #   respond "couchdb" => "Welcome", "version" => "#{adapter.db_version} (#{Mongo::VERSION})"
      # else  
      #   redirect "/_utils/index.html"
      # end
      respond "couchdb" => "Welcome", "version" => "#{adapter.db_version} (#{Mongo::VERSION})"
    end
      
    # all_dbs
    get "/_all_dbs" do
      respond all_dbs
    end
      
    # config
    get "/_config" do
      # TODO
    end
    
    # stats
    get "/_stats" do 
      # TODO
    end
    
    # UUIDs
    get "/_uuids" do # (takes a count parameter)
      count = params[:count].nil? ? 1 : params[:count].to_i
      headers "Cache-Control" => "must-revalidate, no-cache", 
              "Pragma" => "no-cache"
      respond "uuids" => (1..count).map { Mongo::ObjectID.new.to_s }
    end
    
    post "/_uuids" do
      headers "Allow" => "GET"
      error "method_not_allowed", "Only GET allowed", 405
    end
    
    put "/_uuids" do
      headers "Allow" => "GET"
      error "method_not_allowed", "Only GET allowed", 405
    end
    
    delete "/_uuids" do
      headers "Allow" => "GET"
      error "method_not_allowed", "Only GET allowed", 405
    end
    
    # replicate
    post "/_replicate" do # (see Replication)
      # TODO ?
    end
    
    # Database Level Requests
    
    # create
    put "/:db/?" do
      if adapter.db_exists?(db_name)
        error "file_exists", "The database could not be created, the file already exists.", 412
      else
        adapter.create_db(db_name)
        headers "Location" => location(db_name)
        ok 201
      end
    end
    
    # drop
    delete "/:db/?" do
      adapter.drop_db(db_name)
      ok
    end
    
    # info
    get "/:db/?" do
      respond adapter.db_infos(db_name)
    end
    
    # all_docs
    get "/:db/_all_docs" do
      database = db
      conditions = {}
      
      # results for pagination
      if !startkey_docid.nil?
        conditions["_id"] = { "$gte" => startkey_docid.probable_value }
        
      # Design documents are stored in the special (hidden) collection '__design'
      elsif startkey.design? && endkey.design?
        puts "It's a __design query ? (startkey : #{startkey.string} #{startkey.design?}, endkey : #{endkey.string} #{endkey.design?})"
        database = design_db
        
      elsif (!params[:startkey].nil? || !params[:endkey].nil?)
        conditions["_id"] = {}
        
        # for docid lookup...
        if !params[:startkey].nil? && !params[:endkey].nil? && params[:limit] == "10" && params[:endkey].gsub("\"", "") =~ /.*[z]{3}$/
          conditions["_id"] = Regexp.new(startkey.string)
        else
          conditions["_id"]["$gte"] = startkey.probable_value if startkey
          conditions["_id"]["$lte"] = endkey.probable_value if endkey
        end
      end
      list_documents adapter.find(database, conditions, query_options)
    end
    
    post "/:db/_all_docs" do
      begin
        keys = body["keys"]
        raise "`keys` member must be a array." unless keys.is_a? Array
        list_documents adapter.find(db, { "_id" => { "$in" => keys.map { |k| Cliclac::Key.new(k, true).probable_value } }})
      rescue Cliclac::InvalidDocumentError
        error "bad_request", "Request body must be a JSON object", 400
      rescue => e
        error "bad_request", e, 400
      end
    end
    
    # open_doc
    get "/:db/*" do
      options = { 
        :revs_info => params[:revs_info] == "true",
        :local_seq => params[:local_seq] == "true"
      }
      doc = adapter.find_one(db, params[:splat].join("/"), options)
      if doc.nil?
        error_not_found
      else
        respond doc
      end
    end
    
    # save_doc (CREATE)
    post "/:db/?" do
      begin
        res = adapter.insert(db, body)
        headers "Location" => location(db_name, res.to_s)
        ok 201, :id => res.to_s, :rev => 1
      rescue Cliclac::OperationFailure => e
        error "doc_validation", e.to_s
      rescue Cliclac::InvalidDocumentError => e
        error "bad_request", "Request body must be a JSON object", 400
      end
    end
    
    # save_doc (UPDATE)
    put "/:db/:doc_id" do
      begin
        doc_id = params[:doc_id]
        res = adapter.update(db, doc_id, body)
        headers "Location" => location(db_name, doc_id)
        status_code = params["batch"] == "ok" ? 202 : 201
        ok status_code, "id" => doc_id, "rev" => "1"
      rescue Cliclac::InvalidDocumentError => e
        error "bad_request", "Document must be a JSON object", 400
      rescue => e
        error "doc_validation", e.to_s
      end
    end
    
    copy "/:db/:doc_id" do
      begin
        doc_id = params[:doc_id]
        destination_id = @env["HTTP_DESTINATION"]
        raise "badarg" if destination_id.nil?
        res = adapter.copy(db, doc_id, destination_id)
        ok 201, :id => res.to_s, :rev => 1
      rescue Cliclac::UpdateConflictError
        error "conflict", "Document update conflict.", 409
      rescue Cliclac::NotFoundError
        error_not_found
      rescue => e
        error "unknown error", e
      end
    end
    
    # remove_doc
    delete "/:db/*" do
      doc_id = params[:splat].join("/")
      if adapter.remove(db, doc_id)
        ok 200, "_id" => doc_id, "rev" => "1"
      else
        error_not_found
      end
    end
    
    # bulk_docs
    post "/:db/_bulk_docs" do
      begin
        docs = body["docs"]
        puts Cliclac::InvalidDocumentError if !body.is_a?(Hash) || !docs.is_a?(Array) || docs.nil?
        respond docs.map { |doc| { "id" => adapter.update(db, {"_id" => doc["_id"]}, doc), "rev" => 1 } }, 201
      rescue => e
        error "bad_request", e.to_s, 400
      end
    end
    
    # query (aka temporary view)
    post "/:db/_temp_view" do
      q = Yajl::Parser.new.parse(@request.body.read)
      if q["language"] == "javascript"
        respond adapter.mapreduce(db, q["map"], q["reduce"] || "")
      end
    end
    
    # view
    get "/:db/_design/:design_name/_view/:viewname" do
    
    end
  end
end