Rails.application.routes.draw do
  namespace 'api'do
    namespace 'v1' do
      resources :user
      resources :image
      resources :container
      resources :env
      resources :volume
      resources :mount
    end
  end
  post '/magicklink', to: 'magicklink#create'
  post '/login', to: 'login#create'
  post '/logout', to: 'logout#create'
end
