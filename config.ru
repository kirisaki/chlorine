# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

Docker.url = Settings.dir.docker
url = URI.parse('http://proxy:2019/config/apps')
http = Net::HTTP.new(url.host, url.port)
query = {
  http: {
    servers: {
      Settings.server => {
        listen: [':80'],
        routes: [{
          match: [
            { host: [Settings.host], path: ['/api/*'] } 
          ],
          handle: [
            { handler: 'reverse_proxy', upstreams: [{ dial: 'api:3000' }] }
          ]
        }]
      } } } }.to_json
http.put url.path, query, { 'Content-Type' => 'application/json' }
run Rails.application
Rails.application.load_server
