class MicropostsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: [:update, :destroy]

  respond_to :html, :json

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      create_translations
      flash[:success] = t('flash.micropost_created')
      redirect_to locale_root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # def update
  #   micropost = params[:micropost]
  #   micropost[:content] = wrap(micropost[:content], false)
  #   # @micropost.update_attributes(params[:micropost])
  #   @micropost.update_attributes(micropost)
  #   respond_with_bip @micropost
  # end

  def destroy
    @micropost.destroy
    redirect_to locale_root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def create_translations
      I18n.available_locales.each do |locale|
        next if locale == I18n.locale
        @micropost.translations.create(locale: locale,
                                       content: micropost_params[:content])
      end
    end

    def correct_user
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to locale_root_url
    end
end