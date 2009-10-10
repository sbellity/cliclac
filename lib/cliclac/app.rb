module Cliclac
  class App < Sinatra::Default
    
    include Cliclac::Helpers
    
    set :public, File.expand_path(ROOT_PATH + "/../public")
    
    before do
      content_type "application/json"
    end
    
    # info
    get "/" do 
      respond adapter.db_type => "Welcome", "version" => adapter.db_version
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
      referrer = URI.parse(request.env["HTTP_REFERER"])
      database = db CGI::unescape(referrer.query)
      if database
        respond "uuids" => [database.insert({}).to_s] 
      else 
        error_not_found
      end
    end
    
    # replicate
    post "/_replicate" do # (see Replication)
      # TODO ?
    end
    
    # Database Level Requests
    
    # Note: Document names must always have embedded / translated to %2F. 
    # E.g. "get /db/foo%2fbar" for the document named "foo/bar". Attachment names may have embedded slashes.
    
    # compact
    post "/:db/_compact" do
      # Specific to CouchDB
    end
    
    # create
    put "/:db/?" do
      adapter.create_db(db_name)
      ok 201
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
        
      elsif (!startkey.nil? || !endkey.nil?)
        
        # for docid direct access...
        if !startkey.nil? && !endkey.nil? && params[:limit] == "10" && endkey[-1] == 122
          s = Mongo::ObjectID.from_string(startkey.ljust(24, "0")) rescue startkey.probable_value
          e = Mongo::ObjectID.from_string(endkey.gsub("z", "f").ljust(24, "f")) rescue endkey.probable_value
          conditions["_id"] = { "$gte" => s, "$lte" => e }
        else
          conditions["_id"] = {}
          conditions["_id"]["$gte"] = startkey if startkey
          conditions["_id"]["$lte"] = endkey if endkey
        end
      end
      
      respond adapter.find(database, conditions, query_options)
    end
    
    # open_doc
    get "/:db/:doc_id" do
    
    end
    
    # save_doc (CREATE)
    post "/:db" do
    
    end
    
    # save_doc (UPDATE)
    put "/:db/:doc_id" do
    
    end
    
    # remove_doc
    delete "/:db/:doc_id" do
    
    end
    
    # bulk_docs
    post "/:db/_bulk_docs" do
    
    end
    
    # query (aka temporary view)
    post "/:db/_temp_view" do
    
    end
    
    # view
    get "/:db/_design/:designname/_view/:viewname" do
    
    end
  end
end