Rails.application.routes.draw do
  namespace 'api'do
    namespace 'v1' do
      resources :user
      resources :images
      resources :containers
      resources :envs
      resources :volumes
      resources :mounts
    end
  end
end
