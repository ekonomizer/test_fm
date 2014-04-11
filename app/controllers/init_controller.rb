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

    calendar = Championship.matches_current_season(user_club)
    data['opponents'] = opponents calendar, user_club
    p 'dffdfdfdfd'
    p data['opponents']
    data['calendar'] = calendar
    data['club_id'] = cached_club.id
    data['user_club_id'] = user_club.id
    data['division'] = user_club.division
    data['coins'] = user_club.coins
    p 'DDDD'
    p data
    data
  end

  def opponents calendar, user_club
    result = []
    opponents_ids = []
    calendar.each do |day|
      if day['id_home'] != user_club.id
        opponents_ids << day['id_home']
      elsif day['id_guest'] != user_club.id
        opponents_ids << day['id_guest']
      end
    end
    UserClub.select(:id, :club_id, :user_id, :division, :coins).where(id: opponents_ids).to_a unless opponents_ids.empty?
  end
end
