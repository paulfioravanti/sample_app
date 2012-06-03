class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    LANGUAGES.transpose.last.each do |locale|
      next if locale == I18n.locale
      @micropost.translations.build(locale: locale, 
                                    content: params[:micropost][:content])
    end
    if @micropost.save
      flash[:success] = t('flash.micropost_created')
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to root_path
    end
end