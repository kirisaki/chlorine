# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# prepare docker
Docker.url = Settings.dir.docker

# prepare Caddy
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
      } } } }

if Rails.env == 'production'
  query[:http][:servers][Settings.server][:tls_connection_policies] = [{}]
  query[:http][:servers][Settings.server][:listen].append ':443'
end

url = URI.parse('http://proxy:2019/config/apps')
http = Net::HTTP.new url.host, url.port
http.put url.path, query.to_json, { 'Content-Type' => 'application/json' }



run Rails.application
Rails.application.load_server
