class InitController < ApplicationController

	def first_request
		logger.info {User.where(user_id: params[:viewer_id])}

    if params[:viewer_id] != nil
      session[:user_id] = params[:viewer_id]
      response_param = (!User.where(user_id: params[:viewer_id]).empty?)? 'can_start' : 'is_new_user'
    else
      response_param = 'without_social'
    end

    @server_params = {response_param => true}
    render :scene
	end

  def auth_window
  end

  def scene
  end
end
