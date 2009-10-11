module Cliclac
  class App < Sinatra::Default
    
    include Cliclac::Helpers
    
    set :public, File.expand_path(ROOT_PATH + "/../public")
    
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
    
    get "/_config/query_servers/" do
      respond({ "javascript" => "/usr/local/bin/couchjs /usr/local/share/couchdb/server/main.js" })
    end
    
    # stats
    get "/_stats" do 
      # TODO
    end
    
    # UUIDs
    get "/_uuids" do # (takes a count parameter)
      count = params[:count].nil? ? 1 : params[:count].to_i
      respond "uuids" => (1..count).map { Mongo::ObjectID.new.to_s }
    end
    
    # replicate
    post "/_replicate" do # (see Replication)
      # TODO ?
    end
    
    # Database Level Requests
    
    # compact
    post "/:db/_compact" do
      # Specific to CouchDB
    end
    
    # create
    put "/:db/?" do
      if adapter.db_exists?(db_name)
        error "file_exists", "The database could not be created, the file already exists.", 412
      else
        adapter.create_db(db_name)
        headers "Location" => "http://#{@env["HTTP_HOST"]}/#{db_name}"
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
          conditions["_id"]["$gte"] = startkey if startkey
          conditions["_id"]["$lte"] = endkey if endkey
        end
      end
      list_documents adapter.find(database, conditions, query_options)
    end
    
    # open_doc
    get "/:db/*" do
      options = { 
        :revs_info => params[:revs_info] == "true",
        :local_seq => params[:local_seq] == "true"
      }
      respond adapter.find_one(db, params[:splat].join("/"), options)
    end
    
    # save_doc (CREATE)
    post "/:db" do
      begin
        doc = Yajl::Parser.new.parse(request.body)
        puts "Calling POST on #{db} with #{doc}"
        res = adapter.insert(db, doc)
        pp res
        respond({ "id" => res.to_s, "rev" => "1" }, 201)
      rescue => e
        error "format", e.to_s, 500
      end
    end
    
    # save_doc (UPDATE)
    put "/:db/:doc_id" do
      begin
        doc = Yajl::Parser.new.parse(request.body)
        puts "Calling PUT on #{db} with #{doc}"
        res = adapter.update(db, doc)
        ok 201, "id" => res.to_s, "rev" => "1"
      rescue 
      end
    end
    
    # remove_doc
    delete "/:db/*" do
      adapter.remove(db, { "_id" => params[:splat].join("/") })
    end
    
    # bulk_docs
    post "/:db/_bulk_docs" do
    
    end
    
    # query (aka temporary view)
    post "/:db/_temp_view" do
      q = Yajl::Parser.new.parse(request.body)
      if q["language"] == "javascript"
        respond adapter.mapreduce(db, q["map"], q["reduce"])
      end
    end
    
    # view
    get "/:db/_design/:design_name/_view/:viewname" do
    
    end
  end
end