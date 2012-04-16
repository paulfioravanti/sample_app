class StaticPagesController < ApplicationController
  before_filter :locale_redirect

  def home

  end

  def help

  end

  def about

  end

  def contact

  end

  private

    def locale_redirect
      if params[:set_locale].present?
        redirect_to action: action_name, locale: params[:set_locale]
      end
    end
end
