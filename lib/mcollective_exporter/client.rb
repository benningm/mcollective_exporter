# mcollective client for mcollective_exporter
#
module MCollectiveExporter
  class Client
    require 'mcollective'

    def initialize
      @rpc = MCollective::RPC::Client.new('prometheus')
      @rpc.progress = false
    end

    def discover
      hosts = {}
      @rpc.reset
      @rpc.list.each do |resp|
        next if resp[:statuscode] != 0
        hosts[resp[:sender]] = resp[:data]
      end
      hosts
    end

    def get(host, target)
      resp = @rpc.custom_request("get", {:target => target}, [host], {:identity => host})
      resp
    end

    def disconnect
      @client.disconnect
    end

  end
end
