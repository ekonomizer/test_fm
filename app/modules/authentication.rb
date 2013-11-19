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
end