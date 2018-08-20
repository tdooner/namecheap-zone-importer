module NamecheapZoneImporter
  class Importer
    def initialize(options: {})
      @options = options
    end

    def import!
      Namecheap.configure do |config|
        config.key = @options[:apikey]
        config.username = @options[:username]
        config.client_ip = '69.12.169.82'
      end

      records = NamecheapRecordParamFormatter.from_zonefile(
        Zonefile.from_file(@options[:zonefile])
      )

      # TODO: Handle TXT records with semicolons in them; for some reason it
      # breaks the parser.
      require 'pry'; binding.pry
      puts Namecheap.dns.set_hosts('opensavannah', 'org', records.namecheap_record_params)
    end
  end
end
