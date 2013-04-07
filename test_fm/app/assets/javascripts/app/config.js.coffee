class window.Config

  constructor:->
    window.server_params ||= {}
    window.texts = new Texts()

  user_id:->
    window.vk_api.flash_vars['viewer_id']