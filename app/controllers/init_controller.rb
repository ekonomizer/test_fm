class InitController < ApplicationController

  caches_page :load_app if Rails.env.include?('production')
  skip_before_action :check_auth, only: [:load_app]

  include VkApiRequests
  include UsersHelper

  CAN_START = 'can_start'
  IS_NEW_USER = 'is_new_user'
  WITHOUT_SOCIAL = 'without_social'

  def load_app
    @server_params ||= {}
    @server_params['env'] =  Rails.env
=begin
    Rack::MiniProfiler.step("fetch projects") do
     p Country.cached_countries
    end
=end
  end

	def first_request
		logger.info {User.where(user_id: params[:user_id])}
    data = {}

    if params[:user_id] != nil

      session[:user_id] = params[:user_id]
      user = User.where(user_id: params[:user_id])[0]
      if user
        response_param = CAN_START
        data = user_stats(user)
      else
        response_param = IS_NEW_USER
      end
    else
      response_param = WITHOUT_SOCIAL
    end

    render :json => {response_param => true, user_stats: data}
  end

end
