class InitController < ApplicationController

	def first_request
		#return unless params[:viewer_id]
		logger.info {User.find_all_by_user_id(params[:viewer_id])}

		if User.find_all_by_user_id(params[:viewer_id]).empty?
			session[:user_id] = params[:viewer_id]
			@user = User.new
			@server_params = {'is_new_user' => true}
			render :scene
			#render :auth_window
		else
			logger.info {"INIT NOTHING"}
			render :scene
		end

	end

  def auth_window
  end

  def scene
  end
end
