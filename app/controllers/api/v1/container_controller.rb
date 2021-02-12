module Api
  module V1
    class ContainerController < ProtectedController
      def index
        limit = params[:limit] ? params[:limit].to_i : 10
        offset = params[:offset] ? params[:offset].to_i : 0
        containers = Container.where('user_id = ?', current_user.id).order(created_at: :desc).limit(limit).offset(offset)
        render json: { containers: containers }
      end

      def show
        id = params[:id]
        container = Container.find(id)
        unless container.user_id == current_user.id
          render json: { error: 'Forbidden' }, status: :forbidden
          return
        end

        render json: container
      end

      def create
        image_id = params[:image_id]
        command = params[:command]

        if !image_id || !command
          render json: { error: 'Bad request' }, status: :bad_request
          return
        end

        image = Image.find(image_id)
        subdomain = current_user.name.dup << '-' << SecureRandom.alphanumeric(16)
        host = subdomain.dup << '.' << Settings.host

        container = Docker::Image.get(image.id_on_docker).run(
          command, { 'NetworkingConfig' => { 'EndpointsConfig' => { 'pool' => {} } } }
        )
        container_entity = Container.create(
          id_on_docker: container.id,
          image_id: image.id,
          subdomain: subdomain,
          user_id: current_user.id
        )

        ip = container.json['NetworkSettings']['Networks']['pool']['IPAddress']
        url = URI.parse('http://proxy:2019/config/apps/http/servers/' << Settings.server << '/routes')
        http = Net::HTTP.new(url.host, url.port)
        http.post url.path, query(host, ip), { 'Content-Type' => 'application/json' }

        render json: container_entity
      end

      def destroy
        container_id = params[:id]
        container = Container.find(container_id)

        host = container.subdomain.dup << '.' << Settings.host
        url = URI.parse('http://proxy:2019/id/' << host)
        http = Net::HTTP.new(url.host, url.port)
        http.delete url.path

        container_docker = Docker::Container.get(container.id_on_docker)
        container_docker.stop
        container_docker.delete
        container.destroy
      end

      private

      def query(host, ip)
        { '@id' => host, handle:
           [{ handler: 'reverse_proxy', upstreams: [{ dial: ip << ':80' }] }], match: [{ host: [host] }]
        }.to_json
      end
    end
  end
end
