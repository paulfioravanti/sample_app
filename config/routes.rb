SampleApp::Application.routes.draw do
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :microposts, only: [:create, :destroy]
    resource  :session,    only: [:new, :create, :destroy]

    get    'signup',  to: 'users#new'
    get    'signin',  to: 'sessions#new'
    delete 'signout', to: 'sessions#destroy'

    get 'help',    to: 'static_pages#help'
    get 'about',   to: 'static_pages#about'
    get 'contact', to: 'static_pages#contact'

    # handles /en|it|ja
    root to: 'static_pages#home', as: "locale_root"
    # handles /en|it|ja/fake-path
    get '*path', to: redirect { |params, request| "/#{params[:locale]}" }
  end

  resources :relationships, only: [:create, :destroy]

  # handles /
  root to: redirect("/#{I18n.default_locale}")
  # handles /bad-locale|anything/valid-path
  get '/*locale/*path', to: redirect("/#{I18n.default_locale}/%{path}")
  # handles /anything|valid-path-but-no-locale
  get '/*path', to: redirect("/#{I18n.default_locale}/%{path}")

end
#== Route Map
# Generated on 29 Jan 2013 23:30
#
# followers_user GET    /:locale/users/:id/followers(.:format) users#followers {:locale=>/en|it|ja/}
#          users GET    /:locale/users(.:format)               users#index {:locale=>/en|it|ja/}
#                POST   /:locale/users(.:format)               users#create {:locale=>/en|it|ja/}
#       new_user GET    /:locale/users/new(.:format)           users#new {:locale=>/en|it|ja/}
#      edit_user GET    /:locale/users/:id/edit(.:format)      users#edit {:locale=>/en|it|ja/}
#           user GET    /:locale/users/:id(.:format)           users#show {:locale=>/en|it|ja/}
#                PUT    /:locale/users/:id(.:format)           users#update {:locale=>/en|it|ja/}
#                DELETE /:locale/users/:id(.:format)           users#destroy {:locale=>/en|it|ja/}
#        session POST   /:locale/session(.:format)             sessions#create {:locale=>/en|it|ja/}
#    new_session GET    /:locale/session/new(.:format)         sessions#new {:locale=>/en|it|ja/}
#                DELETE /:locale/session(.:format)             sessions#destroy {:locale=>/en|it|ja/}
#     microposts POST   /:locale/microposts(.:format)          microposts#create {:locale=>/en|it|ja/}
#      micropost DELETE /:locale/microposts/:id(.:format)      microposts#destroy {:locale=>/en|it|ja/}
#         signup GET    /:locale/signup(.:format)              users#new {:locale=>/en|it|ja/}
#         signin GET    /:locale/signin(.:format)              sessions#new {:locale=>/en|it|ja/}
#        signout DELETE /:locale/signout(.:format)             sessions#destroy {:locale=>/en|it|ja/}
#           help GET    /:locale/help(.:format)                static_pages#help {:locale=>/en|it|ja/}
#          about GET    /:locale/about(.:format)               static_pages#about {:locale=>/en|it|ja/}
#        contact GET    /:locale/contact(.:format)             static_pages#contact {:locale=>/en|it|ja/}
#    locale_root        /:locale(.:format)                     static_pages#home {:locale=>/en|it|ja/}
#                GET    /:locale/*path(.:format)               :controller#:action {:locale=>/en|it|ja/}
#  relationships POST   /relationships(.:format)               relationships#create
#   relationship DELETE /relationships/:id(.:format)           relationships#destroy
#           root        /                                      :controller#:action
#                GET    /*locale/*path(.:format)               :controller#:action
#                GET    /*path(.:format)                       :controller#:action
