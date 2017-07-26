module MCollective
  module Agent
    class Prometheus<RPC::Agent
      require 'yaml'
      require "net/http"
      require "uri"

      @@config_file = '/etc/prometheus-targets.yml'

      activate_when do
        File.exists?(@@config_file)
      end

      def startup_hook
        @targets = YAML.load_file(@@config_file)
      end

      action 'list' do
        reply[:targets] = @targets.keys
      end

      action 'get' do
        uri = URI.parse( @targets[request[:target]] )
        response = Net::HTTP.get_response(uri)
        reply[:content] = response.body
        reply[:code] = response.code
        reply[:message] = response.message
      end

    end
  end
end

