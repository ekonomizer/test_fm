class UsersController < ApplicationController
  include ClubsHelper
  include UsersHelper
=begin
	def create
		logger.info {'USR CREATE'}

		params[:user]['user_id'] = session['user_id']
		logger.info {params[:user]}
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save!
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

    @@mutex.synchronize do
      user_id = session['user_id']
      login = session['login']
      if user_id || login
        raise "not have all params #{params}" if !params['base_career'] || !params['user_club_id'] || !params['manager']
        raise "not have all params #{params}" if login && (!params['login'] || !params['password'])
        raise 'user with same user_id already created' if user_id != nil && !User.where(user_id: user_id).empty?

        if params['login'] && !User.where(login: params['login']).empty?
          p 'user with same login already created'
          render :json => {user_busy: true}
          return
        end

        user_club = UserClub.find(params['user_club_id'])
        raise "no user_club with #{params['user_club_id']} user_club_id" unless user_club
        if user_club.user_id
          p "user_club is already used by user with id #{user_club.user_id}"
          render :json => {new_clubs: get_free_clubs_response}
          return
        end

        data = {}
        data['user_id'] = user_id if user_id
        data['club_id'] = params['user_club_id']
        params.each_pair do |k,v|
          data[k] = v if %w(login password manager base_career).include? k
        end
        user = ActiveRecord::Base.transaction {
          user = User.create(data)
          raise 'user invalid in create' unless user
          user_club.user_id = user.id
          user_club.coins = ApplicationConfig.default_coins
          user_club.save!
          user
        }
        render :json => {success_create: true, user_stats: user_stats(user, user_club)}
      end

    end
  end

  @@counter = 0
  @@mutex = Mutex.new

  def test_threads
    @@mutex.synchronize do
      counter = @@counter
      sleep 1
      counter += 1
      @@counter = counter
    end
    render text: "#{@@counter}"

  end

	private
	def user_params
		params.require(:user).permit(:user_id, :login)
	end
end
