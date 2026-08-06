# frozen_string_literal: true

Rails.application.routes.draw do
  # Public routes
  get 'faq', to: 'public#faq'
  get 'researchers', to: 'public#researchers'
  get 'participants', to: 'public#participants'
  get '/', to: 'public#home'

  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  # Signup flow
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/u/:id/select-role', to: 'users#select_role'
  post '/u/:id/select-role', to: 'users#select_role_action'

  #  Routes for confirming
  get '/await-confirmation', to: 'authentication#await_confirmation'
  get '/await-confirmation/resend-confirmation', to: 'authentication#resend_confirmation'
  get '/confirm', to: 'authentication#confirm'
  get '/confirm-provisional', to: 'authentication#confirm_provisional'

  #  Routes for forgot password
  get '/forgot-password', to: 'authentication#forgot_password'
  post '/forgot-password', to: 'authentication#forgot_password_action'
  get '/reset-password', to: 'authentication#reset_password', param: :pin

  resources :users, except: %i[index new create], path: 'u'
  get '/change-password', to: 'authentication#change_password'
  put '/change-password', to: 'authentication#change_password_action'

  resources :user_invitations, only: %i[index create], path: 'invite'

  # Admin routes
  get 'admin/stats', to: 'admin#stats'

  namespace :p do
    get '/', to: '/p/participants#index'
    resources :connections, only: %i[index]
    resources :invitations, only: %i[create]
    resources :participants, except: %i[index create]

    resources :researchers, only: :show
    get '/digital-studies', to: 'studies#digital_studies'
    resources :studies, only: %i[show]
  end

  namespace :r do
    get '/', to: '/r/researchers#home'
    resources :researchers, except: :index

    resources :studies, except: [:destroy] do
      member do
        post 'publish'
      end
      collection do
        get 'closed'
      end

    end
    resources :connections, only: [:update]
    # resources :participants, only: [:show]
  end

  scope :api do
    post '/location', to: 'api#location'
  end

  # Test endpoints (available in development and test environments)
  post '/test/seed', to: 'test/seeding#seed'
  post '/test/cleanup', to: 'test/seeding#cleanup'

  get '*path', to: redirect('/')
end
