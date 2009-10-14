module Cliclac
  class App < Sinatra::Default
    # Mocking CouchDB specific functionalities. just for testing...
    get "/_config/query_servers/?" do
      respond({ "javascript" => "/usr/local/bin/couchjs /usr/local/share/couchdb/server/main.js" })
    end
    
    get "/_config/native_query_servers/?" do
      respond({})
    end
    
    post "/:db/_ensure_full_commit/?" do
      ok 201, :instance_start_time => Time.now.to_i * 1000
    end
    
    post "/_restart/?" do
      ok
    end
    
    # compact
    post "/:db/_compact" do
      # Specific to CouchDB
    end
    
  end
end