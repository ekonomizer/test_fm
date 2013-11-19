class window.Config

  constructor:->
    window.server_params ||= {}
    window.texts = new Texts()
    window.protocol = if window.server_params.ssl
      'https://'
    else
      'http://'

    @set_env()

  set_env:->
    switch window.server_params.env
      when "development" then window.path = '//localhost:3000/'
      when "development_ssl" then window.path = '//localhost:3001/'
      when "production" then window.path = '//ec2-54-204-28-218.compute-1.amazonaws.com/'
      when "production_ssl" then window.path = '//ec2-54-204-28-218.compute-1.amazonaws.com/'
      else window.path = '//localhost:3000/'

  user_id:->
    window.social_api.flash_vars['viewer_id'] if window.social_api && window.social_api.flash_vars

  api_url:(api_name)->
    switch api_name
      when "vk" then '//vk.com/js/api/xd_connection.js?2'
      else null
