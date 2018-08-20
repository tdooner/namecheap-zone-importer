require 'namecheap'
require 'zonefile'

module NamecheapZoneImporter
  autoload :FromCommandLine, 'namecheap_zone_importer/from_command_line'
  autoload :Importer, 'namecheap_zone_importer/importer'

  def self.from_command_line(argv)
    options = FromCommandLine.parse!(argv)

    Importer.new(options: options)
  end
end
