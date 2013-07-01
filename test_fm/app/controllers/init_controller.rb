class InitController < ApplicationController

	def first_request
		#return unless params[:viewer_id]
		logger.info {User.where(user_id: params[:viewer_id])}

		if User.where(user_id: params[:viewer_id]).empty?
      response_param = params[:viewer_id]? 'is_new_user' : 'without_social'

      session[:user_id] = params[:viewer_id] if params[:viewer_id]

			#@user = User.new
			@server_params = {response_param => true}
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
