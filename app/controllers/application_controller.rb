class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :locale_redirect
  
  private

    def set_locale
      # I18n.locale = params[:locale] if params[:locale].present?
      # current_user.locale
      # request.subdomain
      # request.env["HTTP_ACCEPT_LANGUAGE"]
      # request.remote_ip
      if params[:locale].present?
        if I18n.available_locales.include?(params[:locale].to_sym) 
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
      
      # redirect_action variable exists in case a locale change is made upon
      # an error screen on create or update.  Rather than redirect back to
      # index, it will now redirect to new or edit respectively.
      @redirect_action = case
        when action_name == "create" then "new"
        when action_name == "update" then "edit"
        else action_name
      end
    end
    
    # Every helper method dependent on url_for (e.g. helpers for named 
    # routes like root_path or root_url, resource routes like books_path 
    # or books_url, etc.) will now automatically include the locale in 
    # the query string,
    def default_url_options(options = {})
      { locale: I18n.locale }
    end

    def locale_redirect
      if params[:set_locale].present?
        redirect_to action: action_name, locale: params[:set_locale]
      end
    end
end
