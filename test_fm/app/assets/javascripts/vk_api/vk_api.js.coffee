class window.VkApi
  @flash_vars: {}
  constructor:->
    @succes_initialization = false
    @requests = []
    VK.init(=>
      @set_flash_vars()
      @succes_initialization = true
      @call_requests()
    )

  set_flash_vars:->
    #узнаём flashVars, переданные приложению GET запросом.
    parts = document.location.search.substr(1).split("&");

    @flash_vars = {}
    for part in parts
      curr = part.split('=')
      @flash_vars[curr[0]] = curr[1]

  resize_window:(coords)->
    VK.callMethod("resizeWindow", coords.width, coords.height) if @succes_initialization

  add_request_in_queue_and_call:(params)->
    @requests.push params
    @call_requests(params) if @succes_initialization

  call_requests:->
    for request in @requests
      switch request.name
        when 'resize_window'
          @resize_window(request.params)
        when 'get_profiles'
          VK.api("getProfiles", request.params, request.callback) if @succes_initialization

  get_profiles:(uids, callback)->
    @add_request_in_queue_and_call({name: "get_profiles", params: {uids: uids, fields: "photo_big"}, callback: callback})