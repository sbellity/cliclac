module Cliclac
  module Adapters
    class Mongo < Cliclac::Adapters::Base
      
      attr_reader :connection, :options
      
      def self.default_separator
        '::'
      end
      
      def initialize(options={})
        raise ArgumentError unless options.is_a?(Hash)
        @options = options
        @options[:separator] ||= Cliclac::Adapters::Mongo::default_separator
        @options[:design_collection] ||= "__design"
        @connection = ::Mongo::Connection.new(options[:host], options[:port])
      end
      
      def db_type
        "MongoDB"
      end
      
      def db_version
        @db_version || "#{db_type}-#{`mongo --version`.split(":")[1].strip}"
      end
      
      def db_infos(d)
        puts "getting db_infos on #{db(d).name}"
        {
          :db_name => d,
          :doc_count => db(d).count,
          :disk_size => 123
        }
      end
      
      def database_names *args
        opts = args.extract_options!
        filters = [Regexp.new(args.first || ".*")]
        filters <<  /^(?!(system\..*))/ unless opts[:include_system]
        filters << /^(?!^__design$)/ unless opts[:include_design]
        
        connection.database_names.inject({}) do |dbs, d|
          dbs.merge({ d => connection.db(d).collection_names.select { |c| filters.nil? ? true : filters.all? { |f| c =~ f } } })
        end.map { |d,cs| cs.map { |c| [d,c].join(@options[:separator]) } unless cs.empty? }.flatten.compact.sort
      end
      
      def db(d)
        db_name, col_name = db_and_col_names(d)
        connection.db(db_name).collection(col_name) rescue nil
      end
      
      def design_db(d)
        db_name, col_name = db_and_col_names(d)
        connection.db(db_name).collection(@options[:design_collection]) rescue nil
      end
      
      
      def db_exists?(d)
        db_name, col_name = db_and_col_names(d)
        if !connection.database_names.include?(db_name) || !connection.db(db_name).collection_names.include?(col_name)
          false 
        else 
          true
        end
      end
      
      def create_db(d)
        db_name, col_name = db_and_col_names(d)
        connection.db(db_name).create_collection(col_name) unless db_exists?(d)
      end
      
      def drop_db(d)
        db_name, col_name = db_and_col_names(d)
        connection.db(db_name).drop_collection(col_name)
      end
      
      def find(d, conditions={}, options={})
        d = self.db(d) if d.is_a?(String)
        options[:skip] ||= 0
        cur = d.find conditions, options
        {
          :total_rows => cur.count,
          :rows => cur.to_a,
          :skip => options[:skip] || 0
        }
      end
      
      def find_one(d, doc_id, options={})
        include_revs_info = options.delete(:revs_info)
        include_local_seq = options.delete(:local_seq)
        
        d = db(d) if d.is_a?(String)
        doc_id = Cliclac::Key.new(doc_id) unless doc_id.is_a?(Cliclac::Key)
        doc = d.find_one({"_id" => doc_id.probable_value}, options)
        doc ||= d.find_one({"_id" => { "$in" => doc_id.possible_values }}, options)
        
        # include revs_info ?
        doc.merge!({ "_revs_info" => [{"rev" => "1", "status" => "available"}] }) if include_revs_info

        # include local_seq ?
        doc.merge!({ "_local_seq" => "1" }) if include_local_seq
        
        
        doc.merge!({"_rev" => "1"})
      end
      
      def insert(d, doc)
        d = db(d) if d.is_a?(String)
        d.insert(doc)
      end
      
      def update(d, doc, options={})
        options[:upsert] ||= true
        d = db(d) if d.is_a?(String)
        spec = { "_id" => Cliclac::Key.new(doc["_id"], true).probable_value }
        d.update(spec, doc, options)
        Cliclac::Key.new(doc["_id"], true).probable_value.to_s
      end
      
      def remove(d)
        d = db(d) if d.is_a?(String)
        spec = { "_id" => Cliclac::Key.new(doc["_id"], true).probable_value }
        d.remove(spec)
      end
      
      def mapreduce(d, map, reduce="", options={})
        d = db(d) if d.is_a?(String)
        puts "\n\n\n\n\n--------------\nMapreduce HERE !"
        mr = OrderedHash.new
        mr["mapreduce"] = d.name
        mr["map"] = "function() { var doc=this; return #{map} }";
        pp mr
        res = d.db.db_command(mr)
      end
      
      private
      
      def db_and_col_names(*d)
        if d.length == 1
          db_name, col_name = d.first.split(@options[:separator])
          col_name ||= "default"
        elsif d.length == 2
          db_name, col_name = d
        end
        [db_name, col_name]
      end
      
      def database(d)
        connection.db db_and_col_names(d)[0]
      end
      
      def collection(d)
        database(d).collection(db_and_col_names(d)[1])
      end
      
    end
  end
end