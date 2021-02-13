class LoginController < ApplicationController
  def create
    payload = JSON.parse(request.body.string)
    name = payload['name']
    pass = payload['pass']

    if !name || !pass 
      render json: { error: 'Empty field' }, status: :bad_request
      return
    end

    Argon2::Password.create(pass)
    user = User.find_by(name: name, fingerprint: fingerprint)

    if user
      token = SecureRandom.alphanumeric(128)
      user.token = token
      user.save
      render json: { token: token }
    else
      render json: { error: 'Not found' }, status: :not_found
    end
  end
end
