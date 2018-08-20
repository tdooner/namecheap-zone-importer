module NamecheapZoneImporter
  # Convert an array of zonefile entries to an object that can be POSTed to
  # Namecheap, like:
  # {
  #   HostName1: 'www',
  #   RecordType1: 'A',
  #   Address1: '127.0.0.1',
  #   # ...
  #   HostName2: 'mail',
  #   # ...
  # }
  class NamecheapRecordParamFormatter
    def self.from_zonefile(zonefile)
      new(zonefile.origin, zonefile.records)
    end

    def initialize(origin, records)
      @origin = origin
      @records = convert_records(records)
    end

    def namecheap_record_params
      @records.each_with_index.each_with_object({}) do |(record, i), hash|
        hash.merge!(Hash[record.map { |k, v| ["#{k}#{i + 1}", v] }])
      end
    end

    private

    def convert_records(records)
      records.flat_map do |record_type, type_records|
        case record_type
        when :txt
          type_records.map { |record| record_param_from_txt(record) }
        when :mx
          type_records.map { |record| record_param_from_mx(record) }
        when :spf
          type_records.map { |record| record_param_from_txt(record) }
        when :ns
          type_records.map { |record| record_param_from_ns(record) }
        else
          type_records.map { |record| record_param(record, record_type) }
        end
      end.compact
    end

    def record_param_from_mx(record)
      record_param(record, :mx).merge(
        MXPref: record[:pri]
      )
    end

    def record_param_from_txt(record)
      {
        HostName: remove_origin_from_hostname(record[:name]),
        Address: record[:text],
        RecordType: 'TXT',
        TTL: record[:ttl],
      }
    end

    def record_param_from_ns(record)
      hostname = remove_origin_from_hostname(record[:name])
      # Namecheap forbids setting NS records for the apex domain via this API
      # call.
      return if hostname == '@'

      record_param(record, :ns)
    end

    def record_param(record, type)
      {
        HostName: remove_origin_from_hostname(record[:name]).downcase,
        Address: record[:host].downcase,
        RecordType: type.to_s.upcase,
        TTL: record[:ttl]
      }
    end

    # convert "foo.openoakland.org." with origin "openoakland.org." to just
    # "foo"
    def remove_origin_from_hostname(hostname)
      if hostname == @origin
        '@'
      elsif hostname.end_with?('.' + @origin)
        hostname.gsub(/\.#{Regexp.escape(@origin)}$/, '')
      else
        raise StandardError.new("Hostname #{hostname} did not match origin #{@origin}")
      end
    end
  end
end
