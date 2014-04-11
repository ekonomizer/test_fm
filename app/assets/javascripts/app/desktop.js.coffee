class window.Desktop

  constructor:->
    @init()

  init:->
    @window = $("#desktop")
    WindowsManager.get().set_window_visible('desktop')
    @club_icon = $("#club_icon")
    @load_club_icon();
    @club_name = $("#club_name")
    @club_name.html(window.texts.club_name)
    @coach_name = $("#coach_name")
    @coach_name.html(window.texts.coach + window.texts.dont_hired)
    @director_name = $("#director_name")
    @director_name.html(window.texts.director + window.texts.dont_hired)
    @user_coins = $("#user_coins")
    @user_coins.html(window.texts.money)

    @match_container = $("#next_matches")
    @match_text = $(".match_text")
    @last_matches = $("#last_matches")
    @next_matches = $("#next_matches")


  start_update:->
    @update_interval_id = setInterval(@update, 1000)

  try_create_matches:->
    last_match = window.calendar.last_match_with_result()
    next_matches = window.calendar.next_matches(2)
    Log.trace('@try_create_matches')

    if last_match
      @create_last_match(last_match)

    unless next_matches.is_empty()
      @next_matches.html(DomHelper.div('next_matches_title', window.texts.next_matches_text))
      for match in next_matches
        @create_next_match(match)

  create_last_match:(last_match)->
    @last_matches.html(DomHelper.div('last_matches_title', window.texts.last_match_text))
    match_text_clone = @match_text.clone()
    home_club_name = window.user_club_manager.user_clubs[last_match.id_home].club.name_ru
    guest_club_name = window.user_club_manager.user_clubs[last_match.id_guest].club.name_ru
    match_text_clone.children(".match_date").html(last_match.date.date_str + ' ')
    match_text_clone.children(".match_clubs").html(home_club_name + " - " + guest_club_name)
    match_text_clone.children(".match_result").html(' ?:?')
    @last_matches.append(match_text_clone)


  create_next_match:(match)->
    match_text_clone = @match_text.clone()
    home_club_name = window.user_club_manager.user_clubs[match.id_home].club.name_ru
    guest_club_name = window.user_club_manager.user_clubs[match.id_guest].club.name_ru
    match_text_clone.children(".match_date").html(match.date.date_str + ' ')
    match_text_clone.children(".match_clubs").html(home_club_name + " - " + guest_club_name)
    match_text_clone.children(".match_result").html(' ?:?')
    @next_matches.append(match_text_clone)

  load_club_icon:->
    img_params = {}
    img_params.alt = "coach"
    img_params.width = "150"
    img_params.src = window.img_path+"boss.jpg"
    img = TagManager.img(img_params)
    @club_icon.html(img)


  update:=>
    Log.trace('update', 'red')
    ready_to_stop_update = 0
    if window.user_club && window.user_club.club && window.user_club.country
      @club_name.html(window.texts.club_name + window.user_club.club.name_ru + ", " + "D" + window.user_club.division + ", " + window.user_club.country.name_ru)
      ready_to_stop_update++

    if window.owner.first_name && window.owner.last_name
      if window.owner.is_coach()
        @coach_name.html(window.texts.coach + window.owner.last_name + " " + window.owner.first_name)
      else
        @director_name.html(window.texts.director + window.texts.dont_hired)
      ready_to_stop_update++

    @user_coins.html(window.texts.money + window.user_club.coins)

    if @match_container.length == 1 && window.calendar.current_season_loaded && @all_clubs_is_loaded()
      ready_to_stop_update++
      @try_create_matches()

    if (ready_to_stop_update == 3)
      clearInterval(@update_interval_id)

  all_clubs_is_loaded:->
    clubs_ids = []
    last_match = window.calendar.last_match_with_result()
    next_matches = window.calendar.next_matches(2)
    if last_match
      clubs_ids.push(last_match.id_home)
      clubs_ids.push(last_match.id_guest)
    for match in next_matches
      clubs_ids.push(match.id_home) unless match.id_home in clubs_ids
      clubs_ids.push(match.id_guest) unless match.id_guest in clubs_ids

    for id in clubs_ids
      return false unless window.user_club_manager.user_clubs[id]
    return true