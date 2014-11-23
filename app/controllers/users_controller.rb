class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end

	def register
		@user = User.new
	end
  

	def create
		@user = User.new(user_params)
		if @user.save
			@userCreated = User.where(name: @user.name).take
			redirect_to action: 'show',id: @userCreated.id
		else
			@title = "Sign up failed"
			render 'register'
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password)
	end
end