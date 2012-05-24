class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = t('flash.invalid_credentials')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
