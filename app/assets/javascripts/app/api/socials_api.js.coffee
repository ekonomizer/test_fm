class window.SocialsApi
  @flash_vars: {}

  constructor:(callback)->
    @on_api_load = callback
    @succes_initialization = false
    @requests = []
    @flash_vars = {}
    $.getScript(@api_url(), @on_loaded)

  on_loaded:=>


  on_init:=>
    @set_flash_vars()
    @succes_initialization = true
    @call_requests()
    @on_api_load()

  set_flash_vars:->
    #узнаём flashVars, переданные приложению GET запросом.
    parts = document.location.search.substr(1).split("&");

    for part in parts
      curr = part.split('=')
      @flash_vars[curr[0]] = curr[1]

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

  @get_api:->
    api_url = Utils.parse_url_query()['api_url']
    switch api_url
      when "//api.vk.com/api.php" then VkApi
      else null

  api_url:->
    null
