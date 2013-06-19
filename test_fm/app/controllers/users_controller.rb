class UsersController < ApplicationController

=begin
	def create
		logger.info {'USR CREATE'}

		params[:user]['user_id'] = session['user_id']
		logger.info {params[:user]}
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
				format.html { redirect_to '/init/scene', notice: 'Product was successfully created.' }
				format.json { render json: @user, status: :created, location: @user }
			else
				format.html { redirect_to '/init/scene', notice: 'Product was successfully created.' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end
=end
	def create
		if session['user_id']
			begin
				user = User.new
				user.user_id = session['user_id']
				user.login = 'test_login'
				user.base_career = params['base_career']
				#user.club_id = params['club_id']
				#user.manager = params['manager']

				raise 'user invalid fr create' unless user.save!
				render :json => {user: session[:user_id]}
			rescue
				raise 'error in create'
			end
		end
	end

	private
	def user_params
		params.require(:user).permit(:user_id, :login)
	end


end