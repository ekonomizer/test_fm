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
    #if window.server_params.is_new_user
    auth_window = new AuthWindow()
    auth_window.visible(true)
    return
    #else
    @bottom_menu.visible(true)

  show_window:(name)->
    $("#"+name).toggle(1000) unless $("#"+name).is(':visible')



