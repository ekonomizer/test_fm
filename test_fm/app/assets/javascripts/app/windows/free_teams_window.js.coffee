class window.FreeTeamsWindow extends BaseWindow



  constructor:->
    @init()

  init:->
    @window = $("#free_teams_window")
    @scrollable_div = '#jp-container'

    @li = $("#free_teams_window #new")
    @li.html(window.texts.free_teams_window_create_new_team)
    @clubs = []
    @clubs.push({id: 'new', li: @li})

    @title = $("#free_teams_window #lable center")
    @title.text(window.texts.free_teams_window_title)
    @greetings = $("#free_teams_window #greetings")
    @greetings.text(window.texts.free_teams_window_choice_club)

    @error_text = $("#free_teams_window #description")
    #@error_text.text(window.texts.choice_base_career_default_bonus)

    @button_next = $("#free_teams_window #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)

    $.getJSON(window.path + 'clubs/free_clubs', {}, @on_clubs_loaded)


  on_clubs_loaded:(e)=>
    for club in e
      last_club_html = @clubs[@clubs.length - 1].li
      club_html = last_club_html.clone().insertAfter(last_club_html)
      club_html.html(club.name + ' (' + club.country + ')')
      club_html.attr('id', club.id)
      @clubs.push({id: club.id.toString(), li: club_html})

    @init_click_handlers()

  init_click_handlers:->
    for club in @clubs
      club.li.click(@select_club)

  select_club:(e)=>
    for club in @clubs
      if club.id == e.currentTarget.id
        window.init_params.club_id = club.id
        break

  on_next_button_click:=>
    if window.init_params && window.init_params.club_id
      data = $.toJSON(window.init_params)
      $.getJSON(window.path + 'users/create', data, @on_loaded)#.done(@on_done).fail(@on_fail).success(@on_loaded).complete(@on_complete).always(@on_always)
      #$.ajax({ url: window.path + 'users/create', dataType: 'json', data: window.init_params, success: @on_succes, error: @on_fail})

      #@close_window(@after_choice_window_close)
    else
      @error_text.text(window.texts.need_choise_club)
      @error_text.addClass('text_warninig')

  on_always:()=>
    alert('always')

  on_loaded:(e)=>
    alert('@@@')
    alert(e)

  on_fail:(e)=>
    alert('fail')

  on_succes:(e)=>
    alert('succes')

  on_done:(e)=>
    alert('on_done')

  on_complete:(e)=>
    alert('on_complete')


  get_scrollable_div:->
    @scrollable_div


