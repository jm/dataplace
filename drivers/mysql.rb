module DataObjects
  module Mysql
    class Connection
      def self.databases(uri)
        uri = DataObjects::URI.parse(uri)
        result = `mysql5 -e 'show databases;' #{ "-u #{uri.user}" if uri.user}  #{ "-u #{uri.user}" if uri.user}  #{ "--socket=#{uri.query['socket']}" if uri.query['socket']}`
      
        # Hooray for scraping.
        (result.split("\n") - ["+--------------------+"]).map {|t| t.gsub(/\|(.*)\|/, '\1').strip} - ["Database"]
      end
    end
  end
end