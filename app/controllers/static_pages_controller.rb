class StaticPagesController < ApplicationController

  before_filter :localized_page, only: [:help, :about, :contact]

  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
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

  private

    def localized_page
      @page = "#{Rails.root}/config/locales/"\
              "#{action_name}/#{action_name}.#{params[:locale].to_s}.md"
    end
end
