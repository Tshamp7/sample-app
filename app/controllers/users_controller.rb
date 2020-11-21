class UsersController < ApplicationController
 before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
 before_action :correct_user, only: [:edit, :update]
 before_action :admin_user

  # shows all users
  def index
    @users = User.paginate(page: params[:page])

  end


  # new displays the page for signing up a new user. Found in new.html.erb.
  def new
    @user = User.new
    render :new
  end

  def show
    @user = User.find(params[:id])
  end

  # The code below will attempt to save a new user with the data submitted
  # using the 'new' function. If the save is not successful, then the errors
  # should be displayed and the 'new' page should be rendered again. 
  def create
    @user = User.new(user_params)
    if @user.save #returns true or false
      flash[:success] = "Welcome to the Sample App!"
      log_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Updates saved!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                         :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def current_user?(user)
      user && user == current_user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
