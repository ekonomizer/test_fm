class window.WindowsManager
  # We can make private variables!
  #instance = null

  # Static singleton retriever/loader
  @get:->
    if not @instance?
      @instance = new @
      @instance.init()
    @instance


  # Example class method for debugging
  init:(name = "unknown")->
    @showed_windows ||= []
    @init_resize_handler()
    @windows_classes = [AuthWindow, ChoiceBaseCareerWindow, FreeTeamsWindow, LoginWithoutSocialWindow, NewsWindow, MatchWindow ]
    @windows = []
    @set_default_windows_positions()
    @set_default_z_index()
    #console.log "#{name} initialized"

  set_default_z_index:->
    for obj in @windows
      obj.window.css('z-index', 0)

  set_default_windows_positions:->
    for window_class in @windows_classes
      window = new window_class
      window.scroll_left()
      @windows.push(window)

  init_resize_handler:->
    $(window).resize(@on_resize)

  on_resize:=>
    @reset_showed_windows_positions()

  reset_showed_windows_positions:->
    for window in @windows
      if (window in @showed_windows)
        window.scroll_center()
      else
        window.scroll_left()

  show_window:(class_window)->
    show_window = null
    for window in @windows
      if (window instanceof (class_window))
        show_window = window
        break

    show_window ||= new class_window()
    show_window.show()
    @showed_windows.push(show_window)
    @set_z_index(show_window)
    #$("#"+name).toggle(1000) unless $("#"+name).is(':visible')

  set_z_index:(window)->
    z_index = if window.always_on_top
      50
    else
      @showed_windows.length
    window.window.css('z-index', z_index)

  set_window_visible:(name)->
    $("#"+name).toggle(1000) unless $("#"+name).is(':visible')

  create_bottom_menu:()->
    @bottom_menu = new BottomMenu()

  close_window:(class_window)->
    for showed_window in @showed_windows
      if (showed_window instanceof (class_window))
        showed_window.close()
        @showed_windows.pop(showed_window)
        showed_window.window.css('z-index', 0)
        return
