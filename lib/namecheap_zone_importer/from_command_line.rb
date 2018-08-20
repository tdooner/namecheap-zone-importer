require 'optparse'

module NamecheapZoneImporter
  # Parse command line arguments into a zone.
  class FromCommandLine
    def self.parse!(argv)
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: #{$PROGRAM_NAME} -f [zone file] -u [namecheap username] -k [namecheap api key]"

        opts.on('-f', '--zonefile MANDATORY', 'Zonefile') do |value|
          options[:zonefile] = value
        end

        opts.on('-u', '--username MANDATORY', 'Namecheap Username') do |value|
          options[:username] = value
        end

        opts.on('-k', '--apikey MANDATORY', 'Namecheap API Key') do |value|
          options[:apikey] = value
        end

        opts.on('-h', '--help') do |value|
          puts opts
          exit
        end
      end.parse!(argv)

      options
    end
  end
end
