module Api
  module V1
    class ImageController < ProtectedController
      def show
        id = params[:id]
        image = Image.find(id)
        unless image
          rende json: { error: 'Image not found' }
          return
        end
        render json: { name: image.name, created_at: image.created_at, updated_at: image.updated_at }
      end

      def create
        image = params[:image]
        begin
          meta = JSON.parse(params[:meta])
        rescue JSON::ParserError
          render json: { error: 'Failed to parse JSON' }, status: :bad_request
          return
        end

        if !meta || !image || !meta.member?('name')
          render json: { error: 'Bad request' }, status: :bad_request
          return
        end

        timestamp = Time.new.strftime('%Y%m%d%H%M%S')
        uuid = SecureRandom.uuid
        filename = timestamp << '-' << uuid << '.tar'
        path = Pathname.new(Settings.dir.image).join(filename)

        File.open Pathname.new(Settings.dir.image).join(filename), 'wb' do |file|
          file.write image.read
        end
        image_loaded = Docker::Image.import(path, { repo: current_user.name, tag: meta['name'] })

        new_image = Image.create(
          id_on_docker: image_loaded.id,
          name: meta['name'],
          filename: filename,
          user_id: current_user.id
        )
        render json: { name: new_image.name, id: new_image.id }
      end
    end
  end
end
