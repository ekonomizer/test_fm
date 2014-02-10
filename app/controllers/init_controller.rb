class InitController < ApplicationController

  caches_page :load_app if Rails.env.include?('production')
  skip_before_action :check_auth, only: [:load_app]

  include VkApiRequests

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
        data = user_stats user.data
      else
        response_param = IS_NEW_USER
      end
    else
      response_param = WITHOUT_SOCIAL
    end

    render :json => {response_param => true, user_stats: data}
  end

  def user_stats data
    user_club = UserClub.find(data['club_id'])
    raise "first_request. no user_club with id = #{data['club_id']}" unless user_club
    cached_club = Club.cached_clubs[user_club.club_id]
    data['club_id'] = cached_club.id
    data['division'] = user_club.division
    data
  end
end
