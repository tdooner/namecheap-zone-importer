require 'namecheap'
require 'zonefile'

module NamecheapZoneImporter
  autoload :FromCommandLine, 'namecheap_zone_importer/from_command_line'
  autoload :Importer, 'namecheap_zone_importer/importer'
  autoload :NamecheapRecordParamFormatter, 'namecheap_zone_importer/namecheap_record_param_formatter'

  def self.from_command_line(argv)
    options = FromCommandLine.parse!(argv)

    Importer.new(options: options)
  end
end
