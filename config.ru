# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

Docker.url = Settings.dir.docker
run Rails.application
Rails.application.load_server
