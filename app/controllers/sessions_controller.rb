class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or(user)
    else
      flash.now[:error] = t('flash.invalid_credentials')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to locale_root_url
  end

  private

    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      session.delete(:return_to)
    end

end
