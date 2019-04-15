Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    invitations: 'users/invitations'
  }
  devise_scope :user do
    scope module: :users do
      resource :profile, only: [:show, :edit, :update]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "mains#index"
  resources :articles, except: [:show] do
    resources :comments, only: [:create, :destroy]
  end
  resources :reactions, only: [:create]

end
