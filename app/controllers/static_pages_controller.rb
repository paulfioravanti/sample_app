class StaticPagesController < ApplicationController

  before_filter(only: [:help, :about, :contact]) do |c|
    c.localized_page(params[:locale])
  end

  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      localized_page(params[:locale])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  protected

    def localized_page(locale)
      if !I18n.available_locales.include?(locale.to_sym)
        locale = I18n.default_locale
      end
      @page = "#{Rails.root}/config/locales/"\
              "#{action_name}/#{action_name}.#{locale}.md"
    end
end
