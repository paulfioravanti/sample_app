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
    
    def locale_redirect
      # redirect_action and redirect_controller variables exist in case a 
      # locale change is made upon an error screen.  Rather than redirect 
      # back to index, it will now redirect to the appropriate page.
      @redirect_action = action_name
      if @redirect_action == 'create'
        @redirect_action = 'new'
      elsif @redirect_action == 'update'
        @redirect_action = 'edit'
      end

      @redirect_controller = controller_name
      if @redirect_controller == 'microposts' && action_name == 'create'
        @redirect_controller = 'static_pages'
        @redirect_action = 'home'
      end

      if params[:set_locale].present?
        options = { controller: @redirect_controller, action: @redirect_action, locale: I18n.locale }
        options[:page] = params[:page] if params[:page]
        redirect_to options
      end
    end
end
