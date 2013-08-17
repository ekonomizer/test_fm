class window.Scene

  init:->
    window.config = new Config()
    window.scene = this
    window.vk_api = new VkApi()
    #@bottom_menu = new BottomMenu()
    #@continue_initialization()
    $.getJSON(window.path + 'init/first_request', {viewer_id: window.config.user_id()}, @first_request_loaded)

  first_request_loaded:(e)=>
    alert('!!!')
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

  @show_window:(name)->
    $("#"+name).toggle(1000) unless $("#"+name).is(':visible')

  @start_game:->
    alert('')
    #WindowsManager.get().show_window(BottomMenu)



