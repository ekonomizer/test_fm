class AuthController < ApplicationController

  include Authentication

  def login
    raise "not have all params #{params}" if !params[:login] || !params[:password]
    raise 'to long login' if params[:login].size > 254
    raise 'to long pass' if params[:password].size > 30

    begin
      user = auth(params)
      if user
        reset_session
        session[:login] = params[:login]
      else
        sleep_if_brut
      end
      render json: {loged_in: user != nil}
    rescue
      sleep 1
      raise 'error in sign in'
    end
  end

  def sleep_if_brut
    if session[request.remote_ip]
      p 'ip in sessions'
      p session[request.remote_ip]
      p (Time.now - session[request.remote_ip][:time])
      if session[request.remote_ip][:count] > 3 && session[request.remote_ip][:count]*2 > (Time.now - session[request.remote_ip][:time])
        session[request.remote_ip] = nil
        sleep 1
      else
        session[request.remote_ip][:count] += 1
      end
    else
      p 'no in sessions'
      session[request.remote_ip] = {count: 1, time: Time.now}
    end
  end

  def sign_in
    raise "not have all params #{params}" if !params[:login] || !params[:password]
    raise 'to long login' if params[:login].size > 254
    raise 'to long pass' if params[:password].size > 30

    begin
      mutex = Mutex.new
      mutex.synchronize do

        response = {}
        user = User.where(login: params[:login])
        p '!!!!!!!'
        p user.empty? == false
        unless User.where(login: params[:login]).empty?
          response[:login_busy] = true
        else
          reset_session
          session[:login] = params[:login]
          response[:signed_in] = true
        end
        render :json => response
      end
    rescue
      raise 'error in sign in'
    end
  end
end
