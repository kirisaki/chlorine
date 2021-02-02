module Api
  module V1
    class ContainerController < ProtectedController
      def create
        image_id = params[:image_id]
        command = params[:command]

        if !image_id || !command
          render json: { error: 'Bad request' }, status: :bad_request
          return
        end

        unless image = Image.find(image_id)
          render json: { error: 'Image not found' }
          return
        end

        container = Docker::Image.get(image.id_on_docker).run(command)
        container_entity = Container.create(id_on_docker: container.id, image_id: image.id)

        render json: container_entity
      end

    end
  end
end
