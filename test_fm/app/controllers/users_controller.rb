class UsersController < ApplicationController

=begin
	def create
		logger.info {'USR CREATE'}

		params[:user]['user_id'] = session['user_id']
		logger.info {params[:user]}
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
				format.html { redirect_to '/init/scene', notice: 'Product was successfully created.' }
				format.json { render json: @user, status: :created, location: @user }
			else
				format.html { redirect_to '/init/scene', notice: 'Product was successfully created.' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end
=end

  def login
    begin
      raise "not have all params #{params}" if !params[:login] || !params[:pass]
      raise 'to long login' if params[:login].size > 254
      raise 'to long pass' if params[:pass].size > 30

      users = User.where(login: params[:login], password: params[:pass])
      session[:login] = params[:login] if users
      render :json => {loged_in: !users.empty?}
    rescue
      raise 'error in sign in'
    end
  end

  def sign_in
    begin
      raise "not have all params #{params}" if !params[:login] || !params[:pass]
      raise 'to long login' if params[:login].size > 254
      raise 'to long pass' if params[:pass].size > 30

      response = {}
      unless User.where(login: params[:login]).empty?
        response[:login_busy] = true
      else
        session[:login] = params[:login]
        response[:signed_in] = true
      end
      render :json => response
    rescue
      raise 'error in sign in'
    end
  end

	def create
		if session['user_id'] || session['login']
      p params
			begin
        raise "not have all params #{params}" if !params['base_career'] || !params['club_id'] || !params['manager']
        if session['user_id'] != nil
          raise 'user with same user_id already created' unless User(user_id: session['user_id']).empty?
        end

        if params['login']
          raise 'user with same login already created' unless User(login: params['login']).empty?
        end

				user = User.new
				user.user_id = session['user_id'] if session['user_id'] != nil
				user.login = params['login'] if params['login']
				user.password = params['pass'] if params['pass']
				user.base_career = params['base_career']
				user.club_id = params['club_id']
				user.manager = params['manager']

				raise 'user invalid in create' unless user.save!
				render :json => {user: true}
			rescue
				raise 'error in create'
			end
		end
	end

	private
	def user_params
		params.require(:user).permit(:user_id, :login)
	end


end
