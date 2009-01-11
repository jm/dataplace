module DataObjects
  class Connection
    class <<self
      def drivers
        load_drivers unless @drivers
        @drivers
      end
      
      private
        def load_drivers
          # Load the available data drivers
          @drivers = ["mysql", "pgsql", "sqlite3"]
          @drivers.each do |d|
            begin
              require "do_#{d}"
              require "drivers/#{d}"
            rescue LoadError
              @drivers.delete(d)
              puts "skipping load of #{d} -- not installed"
            end
          end
        end
    end
  end
end