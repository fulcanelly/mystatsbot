Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  get 'chat_stats', to: 'chat_stats#index'
  get 'chat_stats/:id', to: 'chat_stats#show'

  root "hello_world#index"

  namespace :api do
    namespace :v1 do
      # resources :tg_posts
      resources :chats

      post 'tg_posts', to: 'tg_posts#create'
      get 'tg_posts/posts_per_day', to: 'tg_posts#posts_per_day'
      get 'tg_posts/chat_stats_of_day', to: 'tg_posts#chat_stats_of_day'
      get 'messages_loads/chats_to_load_from', to: 'message_loads#chats_to_load_from'

    end
  end
end
