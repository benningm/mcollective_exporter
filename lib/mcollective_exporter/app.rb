require 'rubygems'
require 'sinatra/base'
require 'json'
require 'mcollective_exporter/client'

module MCollectiveExporter
  class App < Sinatra::Base
    set :bind, '0.0.0.0'
    set :port, 80

    get '/discover' do
      client = MCollectiveExporter::Client.new
      output = []
      client.discover.each do |host,data|
        data[:targets].each do |target|
          output << {
            targets: [ host ],
            labels: {
              :target => target,
            },
          }
        end
      end

      content_type 'text/plain'
      body JSON.pretty_generate(output)
    end

    get '/metrics' do
      content_type 'text/plain'

      if params[:host].nil? || params[:target].nil?
        status 500
        body 'you must supply host and target parameter!'
        return
      end

      client = MCollectiveExporter::Client.new
      resp = client.get(params[:host], params[:target])
      if resp.empty?
        status 404
        body 'no such host or host timed out'
        return
      end
      msg = resp[0]
      if msg[:statuscode] != 0
        status 500
        body "Agent returned: #{msg[:statusmsg]}"
        return
      end

      status msg[:data][:code]
      body msg[:data][:content]
    end

  end
end
