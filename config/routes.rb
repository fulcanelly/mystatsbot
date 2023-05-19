Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  root "hello_world#index"

  namespace :api do
    namespace :v1 do
      resources :tg_posts
      get 'posts_per_day'
    end
  end
end
