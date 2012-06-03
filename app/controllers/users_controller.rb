class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :signed_in_users, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t('flash.welcome')
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = t('flash.profile_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user.admin? && !current_user?(user)
      user.destroy
      flash[:success] = t('flash.user_destroyed')
    else
      flash[:error] = t('flash.no_admin_suicide', name: user.name)
    end
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location # to redirect to original page after signin
        redirect_to signin_path, notice: t('flash.sign_in')
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def signed_in_users
      redirect_to root_path if signed_in?
    end

end
