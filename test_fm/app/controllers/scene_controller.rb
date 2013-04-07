class SceneController < ApplicationController

	def first_request
		return unless params[:viewer_id]
		logger.info {User.find_all_by_user_id(params[:viewer_id])}
		if User.find_all_by_user_id(params[:viewer_id]).empty?
			@user = User.new
			render 'init/auth_window'
		else
			logger.info {"INIT NOTHING"}
			render :entrance_mode
		end

	end
end