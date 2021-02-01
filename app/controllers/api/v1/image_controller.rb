module Api
  module V1
    class ImageController < ApplicationController
      def create
        meta = JSON.parse params[:meta]
        image = params[:image]
        if !meta || !image
          render json: { error: 'Bad request' }, status: :bad_request
          return
        end

        timestamp = Time.new.strftime('%Y%m%d%H%M%S')
        uuid = SecureRandom.uuid
        filename = timestamp << '-' << uuid << '.tar'

        Image.new(filename: filename, user: @current_user)
        File.open Pathname.new(Settings.dir.image).join(filename), 'w+b' do |file|
          file.write image
        end

        render json: { message: 'success' }
      end
    end
  end
end
