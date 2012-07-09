class MicropostsController < ApplicationController
  include MicropostsHelper

  before_filter :signed_in_user, only: [:create, :update, :destroy]
  before_filter :correct_user,   only: [:update, :destroy]

  respond_to :html, :json

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    I18n.available_locales.each do |locale|
      next if locale == I18n.locale
      @micropost.translations.build(locale: locale,
                                    content: params[:micropost][:content])
    end
    if @micropost.save
      flash[:success] = t('flash.micropost_created')
      redirect_to locale_root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def update
    micropost = params[:micropost]
    micropost[:content] = wrap(micropost[:content], false)
    # @micropost.update_attributes(params[:micropost])
    @micropost.update_attributes(micropost)
    respond_with_bip @micropost
  end

  def destroy
    @micropost.destroy
    redirect_to locale_root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to locale_root_path
    end
end