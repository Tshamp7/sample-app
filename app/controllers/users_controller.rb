class UsersController < ApplicationController

  # new displays the page for signing up a new user. Found in new.html.erb.
  def new
    @user = User.new
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
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                         :password_confirmation)
    end

end
