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
      I18n.locale = params[:locale]
    end
    
    def locale_redirect
      # redirect_action variable exists in case a locale change is made upon
      # an error screen on create or update.  Rather than redirect back to
      # index, it will now redirect to new or edit respectively.
      @redirect_action = case
        when action_name == "create" then "new"
        when action_name == "update" then "edit"
        else action_name
      end

      if params[:set_locale].present? 
        redirect_to action: @redirect_action, 
                    locale: params[:set_locale],
                    page: params[:page]
      end
    end
end
