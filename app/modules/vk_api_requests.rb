#:encoding: utf-8
require 'digest/md5'
require 'net/http'
require 'json/ext'
require 'cgi'
require 'base64'


module VkApiRequests

  def create_sign(str)
    api_secret = ApplicationConfig.api_secret
    str.force_encoding('UTF-8') if str.respond_to?(:force_encoding)
    Digest::MD5.hexdigest(str+api_secret.to_s)
  end


  def create_signed_request(cmd, user_params, sig = nil)
    app_id = ApplicationConfig.api_secret
    p = [{:api_id => app_id},
         {:format => 'JSON'},
         {:method => cmd},
         {:random => rand(100000)},
         {:timestamp => Time.now.to_i}]

    if user_params
      if user_params.is_a?(Array)
        p += user_params
      else
        p << user_params
      end
    end

    p.flatten!

    p.sort! { |a, b| a.keys.first.to_s <=> b.keys.first.to_s }

    params = p.map { |i| "#{i.keys.first}=#{i.values.first}" }

    sig = create_sign(CGI.unescape(params.join(''))) unless sig
    req = "http://vk.payments.socialquantum.ru:24545/api.php?#{params.join('&')}&sig=#{sig}"

    logger.warn{"API REQUEST: #{req.to_s}"}
    req.force_encoding('UTF-8') if req.respond_to?(:force_encoding)
    URI.parse(req)
  end

  def request_vkontakte(req)
    uri = req
    h = Net::HTTP.new(uri.host, uri.port)
    h.open_timeout = 5
    h.read_timeout = 10
    h.start {|http|
      return http.request_get(uri.request_uri)
    }
  end








  def request_vkontakte_https(req)
    uri = req
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
    @data = http.get(uri.request_uri)
  end

  def get_cmd(cmd, user_params = nil)
    #logger.warn { "APIREQUEST: #{cmd}; params: #{user_params.inspect}"}
    p "APIREQUEST: #{cmd}; params: #{user_params.inspect}"
    #resp = request_vkontakte(create_signed_request(cmd, user_params))

    resp = request_vkontakte_https(cmd)
    body = JSON.parse(resp.body)
    #logger.info { "APIRESPONCE: #{body.inspect}" }
    p "APIRESPONCE: #{body.inspect}"
    if resp.code.to_i == 200
      return body
    else
      #Rails.logger.info { "API Error: #{body['error']}"}
      p "API Error: #{body['error']}"
      raise "[#{resp.code}] API Error: #{body.inspect}"
    end
  end


  def get_user_balance(uid)
    get_cmd('secure.getBalance', {:uid => uid})['response']['balance']
  end

  def create_app_access_token
    unless @access_token
      uri = URI.parse("https://oauth.vk.com/access_token?client_id=#{ApplicationConfig.app_id}&client_secret=#{ApplicationConfig.api_secret}&grant_type=client_credentials")
      @access_token = get_cmd(uri)['access_token']
    end
  end

  def check_access_token user_id, access_token
    uri = URI.parse("https://oauth.vk.com/access_token?client_id=#{ApplicationConfig.app_id}&client_secret=#{ApplicationConfig.api_secret}&grant_type=client_credentials")
    get_cmd(uri)['success'] == 1
  end


end