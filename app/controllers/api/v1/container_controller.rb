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

        container = Docker::Image.get(image.id_on_docker).run(command, { 'NetworkingConfig' => { 'EndpointsConfig' => { 'pool' => {} } } })
        container_entity = Container.create(id_on_docker: container.id, image_id: image.id)
        ip = container.json['NetworkSettings']['Networks']['pool']['IPAddress']
        url = URI.parse 'http://proxy:2019/config/apps/'
        http = Net::HTTP.new(url.host, url.port)
        query = { http: { servers: { 'a' => { listen: [':80'], routes: [{ handle: [{ handler: 'reverse_proxy', upstreams: [{ dial: ip << ':80' }]}], match: [{ host: ['a.proxy']  }] }] } } } }.to_json
        http.post url.path, query, { 'Content-Type' => 'application/json' }

        render json: container_entity
      end

      def destroy
        container_id = params[:id]
        container = Container.find(container_id)
        container_docker = Docker::Container.get(container.id_on_docker)
        container_docker.stop
        container_docker.delete
        container.destroy
      end
    end
  end
end
