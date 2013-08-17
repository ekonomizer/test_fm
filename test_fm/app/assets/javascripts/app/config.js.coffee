class window.Config

  constructor:->
    window.server_params ||= {}
    window.texts = new Texts()
    window.path = 'http://0.0.0.0:3000/'

  user_id:->
    window.vk_api.flash_vars['viewer_id']