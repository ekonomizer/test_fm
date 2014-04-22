class window.FreeTeamsWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#free_teams_window")
    @always_on_top = true
    @scrollable_div = '#selectable'
    @clubs_container = $("#selectable")

    @li = $("#free_teams_window #new")
    @li.html(window.texts.free_teams_window_create_new_team)

    @title = $("#free_teams_window #lable")
    @title.text(window.texts.free_teams_window_title)
    @greetings = $("#free_teams_window #greetings")
    @greetings.text(window.texts.free_teams_window_choice_club)

    @error_text = $("#free_teams_window #description")

    @button_next = $("#free_teams_window #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)
    #@sup = window.FreeTeamsWindow.__super__


  show:->
    call_super = do (args=arguments) => => super(args...)
    @super_show = ->
      call_super()

    @need_new_login = false
    @error_text.text('')
    @error_text.removeClass('text_warninig')

    request = {action: 'clubs/free_clubs', params: {}, callback: @on_clubs_loaded }
    window.server.add_request_in_queue_and_call(request)
    #$.getJSON(window.path + 'clubs/free_clubs', {}, (e)=>@on_clubs_loaded(e);super())

  on_clubs_loaded:(e)=>
    @clubs = []
    @clubs.push({id: 'new', li: @li})
    @clubs_container.empty()
    @clubs_container.html(@li)
    @fill_clubs_container(e)
    @init_click_handlers()
    @super_show()

  fill_clubs_container:(e)->
    for club in e
      last_club_html = @clubs[@clubs.length - 1].li
      club_html = last_club_html.clone().insertAfter(last_club_html)
      club_html.html(club.name + ' (' + club.country + ')')
      club_html.attr('id', club.id)
      @clubs.push({id: club.id.toString(), li: club_html})


  init_click_handlers:->
    for club in @clubs
      club.li.click(@select_club)

  select_club:(e)=>
    for club in @clubs
      if club.id == e.currentTarget.id
        window.init_params.user_club_id = club.id
        break

  on_next_button_click:=>
    if @need_new_login
      WindowsManager.get().close_window(FreeTeamsWindow)
      WindowsManager.get().show_window(LoginWithoutSocialWindow)
      @need_new_login = false
      return

    if window.init_params && window.init_params.user_club_id
      #data = $.toJSON(window.init_params)
      request = {action: 'users/create', params: window.init_params, callback: @on_team_accept}
      window.server.add_request_in_queue_and_call(request)
      #$.getJSON(window.path + 'users/create', window.init_params, @on_team_accept)
    else
      alert('@@')
      @error_text.text(window.texts.need_choise_club)
      @error_text.addClass('text_warninig')

  on_team_accept:(e)=>
    if e['new_clubs']
      @on_clubs_loaded(e['new_clubs'])
      @error_text.text(window.texts.free_teams_window_team_used)
      @error_text.addClass('text_warninig')
    else if e['user_busy']
      @error_text.text(window.texts.free_teams_window_login_used)
      @error_text.addClass('text_warninig')
      @need_new_login = true
    else if e['success_create']
      WindowsManager.get().close_window(FreeTeamsWindow)
      for k,v of e.user_stats
        window.init_params[k] = v
      Scene.start_game()

  get_scrollable_div:->
    @scrollable_div
