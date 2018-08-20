module NamecheapZoneImporter
  class Importer
    def initialize(options: {})
      @options = options
    end

    def import!
      Namecheap.configure do |config|
        config.key = @options[:apikey]
        config.username = @options[:username]
        config.client_ip = '127.0.0.1'
      end

      puts Namecheap.domains.get_list
    end
  end
end
