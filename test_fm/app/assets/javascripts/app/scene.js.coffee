class window.Scene

  init:->
    window.config = new Config()
    window.scene = this
    @init_api()
    #@bottom_menu = new BottomMenu()

  init_api:->
    api_class = SocialsApi.get_api()
    if api_class
      window.social_api = new api_class(@after_init_api)
    else
      @after_init_api()

  after_init_api:=>
    $.getJSON(window.path + 'init/first_request', {viewer_id: window.config.user_id()}, @first_request_loaded)

  first_request_loaded:(e)=>
    alert('first_request_loaded')
    window.server_params = e
    #window.owner = new User()
    #@server_requests_service = new ServerRequestsService
    windows_manager = WindowsManager.get()

    if window.server_params.without_social
      windows_manager.show_window(LoginWithoutSocialWindow)
    else if window.server_params.is_new_user
      windows_manager.show_window(AuthWindow)
    else if window.server_params.can_start
      @start_game()

  @start_game:->
    alert('')
    #WindowsManager.get().show_window(BottomMenu)



