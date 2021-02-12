module Api
  module V1
    class ImageController < ProtectedController
      def index
        limit = params[:limit] ? params[:limit].to_i : 10
        offset = params[:offset] ? params[:offset].to_i : 0
        images = Image.where('user_id = ?', current_user.id).order(created_at: :desc).limit(limit).offset(offset)
        render json: { images: images }
      end

      def show
        id = params[:id]
        image = Image.find(id)
        unless image.user_id == current_user.id
          render json: { error: 'Forbidden' }, status: :forbidden
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

        image_id = nil
        File.open path, 'wb' do |file|
          file.write image.read
        end
        File.open path, 'rb' do |file|
          tar = Gem::Package::TarReader.new(file)
          tar.each do |entry|
            entry.full_name != 'manifest.json' && next
            json = JSON.parse(entry.read)
            image_id = json[0]['Config'].chomp('.json')
          end
        end
        unless image_id
          render json: { error: 'Invalid image' }
          return
        end
        Docker::Image.load(path.to_s)

        new_image = Image.create(
          id_on_docker: image_id,
          name: meta['name'],
          filename: filename,
          user_id: current_user.id
        )
        render json: { name: new_image.name, id: new_image.id }
      end

      def destroy
        image_id = params[:id]
        image = Image.find image_id
        (Pathname.new(Settings.dir.image) / image.filename).delete
        image.destroy
      end
    end
  end
end
