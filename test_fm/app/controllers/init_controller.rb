class InitController < ApplicationController

  caches_page :load_app if Rails.env == 'production'

  def load_app
    @server_params ||= {}
    @server_params['ssl'] =  Rails.env.split('_').last == 'ssl'
=begin
    Rack::MiniProfiler.step("fetch projects") do
     p Country.cached_countries
    end
=end
  end

	def first_request
		logger.info {User.where(user_id: params[:viewer_id])}

    if params[:viewer_id] != nil
      session[:user_id] = params[:viewer_id]
      response_param = (!User.where(user_id: params[:viewer_id]).empty?)? 'can_start' : 'is_new_user'
    else
      response_param = 'without_social'
    end
    render :json => {response_param => true}
	end
end
