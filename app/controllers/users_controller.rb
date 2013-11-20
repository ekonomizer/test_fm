class UsersController < ApplicationController
  include ClubsHelper
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
        raise "not have all params #{params}" if !params['base_career'] || !params['club_id'] || !params['manager']
        raise "not have all params #{params}" if login && (!params['login'] || !params['password'])
        raise 'user with same user_id already created' if user_id != nil && !User.where(user_id: user_id).empty?
        raise 'user with same login already created' if params['login'] && !User.where(login: params['login']).empty?
        club = UserClub.find(params['club_id'])
        raise "no club with #{params['club_id']} club_id" unless club
        raise "club is already used by user with id #{club.user_id}" if club.user_id
        new_clubs = nil
        unless club.user_id
          data = {}
          data['user_id'] = user_id if user_id
          params.each_pair do |k,v|
            data[k] = v if %w(login password manager base_career club_id).include? k
          end
          user = User.create(data)
          raise 'user invalid in create' unless user
          club.user_id = user.id
          club.save!
        else
          new_clubs = get_free_clubs_response
        end
        render :json => {new_clubs: new_clubs}
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