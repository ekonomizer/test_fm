class window.Config

  constructor:->
    window.server_params ||= {}
    window.texts = new Texts()
    window.path = 'http://localhost:3000/'

  user_id:->
    window.social_api.flash_vars['viewer_id'] if window.social_api && window.social_api.flash_vars

  api_url:(api_name)->
    switch api_name
      when "vk" then 'http://vk.com/js/api/xd_connection.js?2'
      else null
