class window.Scene

  init:->
    window.config = new Config()
    window.scene = this
    #window.vk_api = new VkApi()
    #@bottom_menu = new BottomMenu()
    @continue_initialization()

  continue_initialization:->
    #window.owner = new User()
    #@server_requests_service = new ServerRequestsService
    windows_manager = WindowsManager.get()

    windows_manager.show_window(FreeTeamsWindow)
    return
    if window.server_params.without_social
      windows_manager.show_window(LoginWithoutSocialWindow)
    else if window.server_params.is_new_user
      windows_manager.show_window(AuthWindow)
    else
      windows_manager.show_window(BottomMenu)

  @show_window:(name)->
    $("#"+name).toggle(1000) unless $("#"+name).is(':visible')



