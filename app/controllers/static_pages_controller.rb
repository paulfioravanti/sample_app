class StaticPagesController < ApplicationController

  before_filter :localized_page, only: [:help, :about, :contact]

  def home
    if signed_in?
      @micropost  = current_user.microposts.includes(:translations).build
      @feed_items = current_user.feed.eagerly_paginate(params[:page])
    else
      localized_page
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  protected

    def localized_page
      locale = params[:locale]
      action = action_name
      @page = "#{Rails.root}/config/locales/#{controller_name}/"\
              "#{action}/#{action}.#{locale}.md"
    end
end
