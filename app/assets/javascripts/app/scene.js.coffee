class window.Scene

  init:->
    window.config = new Config()
    window.scene = this
    @init_api()
    #$(document).bind("ajaxSend", @set_session_cockie);
    #@bottom_menu = new BottomMenu()

  init_api:->
    api_class = SocialsApi.get_api()
    if api_class
      window.social_api = new api_class(@after_init_api)
    else
      @after_init_api()

  after_init_api:=>
    window.server = new ServerRequestsService()
    request = {action: 'init/first_request', params: {}, callback: @first_request_loaded}
    window.server.add_request_in_queue_and_call(request)

  set_session_cockie:(xhr)=>
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))

  first_request_loaded:(e)=>
    alert('first_request_loaded')
    window.server_params = e
    window.owner = new User(window.server_params.user_stats)
    #@server_requests_service = new ServerRequestsService
    ItemsManager.get()
    windows_manager = WindowsManager.get()
    if window.server_params.without_social
      windows_manager.show_window(LoginWithoutSocialWindow)
    else if window.server_params.is_new_user
      windows_manager.show_window(AuthWindow)
    else if window.server_params.can_start
      Scene.start_game()

  @start_game:->
    WindowsManager.get().create_bottom_menu()
    @desktop = new Desktop()
    #WindowsManager.get().show_window(DesktopWindow)
    #alert('start_game')
    #WindowsManager.get().show_window(BottomMenu)

  @get_desktop:->
    @desktop



