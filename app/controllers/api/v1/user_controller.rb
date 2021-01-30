module Api
  module V1
    class UserController < ApplicationController
      def index
        render json: { error: "Not allowed" }, status: :forbidden
      end
      def show
        user = User.find_by name: params[:id]
        render json: { name: user.name, mail: user.mail }
      end
    end
  end
end
