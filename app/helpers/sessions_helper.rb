module SessionsHelper

  def sign_in(user)
    #cookies.permanent[:remember_token] = user.remember_token
    session[:user_id] = user.id
    current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user = nil
    #cookies.delete(:remember_token)
    session[:user_id] = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    #@current_user ||= User.find_by_remember_token(cookies[:remember_token])
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
