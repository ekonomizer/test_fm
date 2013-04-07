class UsersController < ApplicationController

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

	def test_json
		some = {user: 1}
		render :json => some
	end

	private
	def user_params
		params.require(:user).permit(:user_id, :login)
	end
end
