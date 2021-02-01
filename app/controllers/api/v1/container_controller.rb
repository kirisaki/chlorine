module Api
  module V1
    class ContainerController < ProtectedController
      def create
        image_id = params[:image_id]

        unless image = Image.find(image_id)
          render json: { error: 'Image not found' }
          return
        end
        info = Docker.info
        render json: info
      end

    end
  end
end
