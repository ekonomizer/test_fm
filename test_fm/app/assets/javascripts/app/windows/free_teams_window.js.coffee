class window.FreeTeamsWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#free_teams_window")
    @scrollable_div = '#jp-container'

    @li = $("#free_teams_window #selectable li")
    @li.html(window.texts.free_teams_window_create_new_team)
    @clubs = []
    @clubs.push({id: 0, li: @li})

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
      @clubs.push({id: club.id, li: club_html})

  on_next_button_click:=>
    if window.init_params && window.init_params.user_club
      @close_window(@after_choice_window_close)
    else
      @error_text.text(window.texts.need_choise_club)
      @error_text.addClass('text_warninig')





  get_scrollable_div:->
    @scrollable_div


