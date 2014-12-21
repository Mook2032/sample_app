class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy

	def show
		@user = User.find(params[:id])
	end
  	
  	def index
    	@users = User.paginate(page: params[:page])
  	end

	def new
		@user = User.new
	end
  
  	def destroy
    	User.find(params[:id]).destroy
	    flash[:success] = "User deleted"
    	redirect_to users_url
  	end

	def create
		@user = User.new(user_params)
		if @user.save
          #not actually getting sent yet
      		@user.send_activation_email
      		#flash[:info] = "Please check your email to activate your account."
          flash[:info] = edit_account_activation_url(@user.activation_token, email: @user.email)
      		redirect_to home_url
		else
			render 'new'
		end
	end

  	def edit
    	@user = User.find(params[:id])
  	end

  	def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(user_params)
	    	flash[:success] = "Profile updated"
      		redirect_to @user
	    else
	    	render 'edit'
	    end
  	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password)
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
      	redirect_to(home_url) unless current_user?(@user)
    end

    def admin_user
      	redirect_to(home_url) unless current_user.admin?
    end


end