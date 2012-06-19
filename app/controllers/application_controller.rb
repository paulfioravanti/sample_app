class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_locale, :locale_redirect
  
  private

    # Every helper method dependent on url_for (e.g. helpers for named 
    # routes like root_path or root_url, resource routes like books_path 
    # or books_url, etc.) will now automatically include the locale in 
    # the query string,
    def default_url_options(options = {})
      { locale: I18n.locale }
    end

    def set_locale
      if params[:set_locale].present?
        I18n.locale = params[:set_locale]
      else
        I18n.locale = params[:locale]
      end
    end
    
    # redirect_action and redirect_controller instance variables exist 
    # in case a locale change is made upon an error screen.  
    # Rather than redirect back to index, it will now redirect to the
    # appropriate page.
    def locale_redirect
      @redirect_action = redirect_action      
      @redirect_controller = redirect_controller

      if params[:set_locale].present?
        options = { controller: @redirect_controller, 
                    action: @redirect_action, 
                    locale: I18n.locale }
        options[:page] = params[:page] if params[:page].present?
        redirect_to options
      end
    end

    def redirect_action
      case action_name
        when 'create' then 'new'
        when 'update' then 'edit'
        else action_name
      end
    end

    def redirect_controller
      case
        when controller_name == 'microposts' && action_name == 'create'
          @redirect_action = 'home'
          'static_pages'
        else controller_name
      end
    end

end
