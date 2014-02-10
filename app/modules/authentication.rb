module Authentication
  def hash_data(data, salt = "")
    Digest::SHA1.hexdigest("#{data}#{salt}")
  end


  def cript_password params
    salt = hash_data("#{params[:login]}")
    hash_data(params[:password], salt)
  end

  def auth params
    User.where(login: params['login'], password: cript_password(params)).first
  end



  def generate_auth_key user_id
    Digest::MD5.hexdigest(ApplicationConfig.app_id.to_s + '_' + user_id.to_s.strip + '_' + ApplicationConfig.api_secret.to_s)
  end

  def generate_sq_sig(user_id)
    Digest::MD5.hexdigest(user_id.to_s+ApplicationConfig.api_secret.to_s)
  end

  def authenticate (req)
    auth_key = req[:auth_key].strip
    check_auth_key =  generate_auth_key req[:user_id]

    good_user = auth_key == check_auth_key
    p "[#{req[:user_id].to_s}] Invalid authentication key! Expecting: #{check_auth_key} & Got: #{auth_key}" unless good_user
    good_user
  end

  def authenticate_with_iphone(params)
    auth_key = params[:iauth].to_s.strip
    check_auth_key = generate_sq_sig(params[:user_id])

    good_user auth_key == check_auth_key
    p "[#{params[:user_id].to_s}] Invalid authentication key! Expecting: #{check_auth_key} & Got: #{auth_key}" unless good_user
    good_user
  end

  def authenticate_request(params)
    if params[:iauth]
      authenticate_with_iphone(params)
    else
      authenticate(params)
    end
  end
end