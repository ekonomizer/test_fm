class window.VkApi extends SocialsApi

  on_loaded:=>
    VK.init(@on_init)
    super

  api_url:->
    window.config.api_url('vk')

  call_requests:->
    for request in @requests
      switch request.name
        when 'resize_window'
          @resize_window(request.params)
        when 'get_profiles'
          VK.api("getProfiles", request.params, request.callback) if @succes_initialization

  resize_window:(coords)->
    VK.callMethod("resizeWindow", coords.width, coords.height) if @succes_initialization

  get_profiles:(uids, callback)->
    @add_request_in_queue_and_call({name: "get_profiles", params: {uids: uids, fields: "photo_big"}, callback: callback})