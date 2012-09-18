class StaticPagesController < ApplicationController

  # Writing before_filter in standard way triggers Dynamic Path Render
  # warning in Brakeman.
  before_filter(only: [:help, :about, :contact]) do |c|
    c.localized_page
  end

  def home
    if signed_in?
      @micropost  = current_user.microposts.includes(:translations).build
      @feed_items = current_user.feed.paginate(include: [:user, :translations],
                                               page: params[:page])
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
      # if !I18n.available_locales.include?(locale.to_sym)
      #   locale = I18n.default_locale
      # end
      @page = "#{Rails.root}/config/locales/"\
              "#{action_name}/#{action_name}.#{locale}.md"
    end
end
