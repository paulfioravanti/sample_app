SampleApp::Application.routes.draw do
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :sessions,      only: [:new, :create, :destroy]
    resources :microposts,    only: [:create, :destroy]

    root to: 'static_pages#home'

    match '/signup',  to: 'users#new'
    match '/signin',  to: 'sessions#new'
    match '/signout', to: 'sessions#destroy', via: :delete

    match '/help',    to: 'static_pages#help'
    match '/about',   to: 'static_pages#about'
    match '/contact', to: 'static_pages#contact'
  end

  resources :relationships, only: [:create, :destroy]

  match '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  match '',      to: redirect("/#{I18n.default_locale}")
end
