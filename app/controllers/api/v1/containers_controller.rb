module Api
  module V1
    class ContainersController < ApplicationController
      def index
        containers = Container.order(created_at: :desc)
        render json: { containers: @containers }
      end
    end
  end
end
