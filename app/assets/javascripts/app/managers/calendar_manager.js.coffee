class window.CalendarManager

  @get:(params)->
    if not @instance?
      @instance = new @
      @instance.init(params)
    @instance


  init:(calendar)->
    @current_season_loaded = false
    @match_dates = []
    @match_date_ids = []

    for day in calendar
      day["home_club"] = window.user_club_manager[day.id_home]
      day["guest_club"] = window.user_club_manager[day.id_guest]
      @match_dates.push(day)
      @match_date_ids.push(day.match_date)

    ItemsManager.get().add_match_dates_in_load_queue(@match_date_ids, @on_match_dates_loaded)


  on_match_dates_loaded:(e)=>
    Log.trace("match_dates_loaded")
    for day in @match_dates
      day["date"] = e[day.match_date]
      day["date"].date = new Date(day["date"].date.replace(' ', 'T'))
      day["date"].date_str = DateHelper.date(day["date"].date)
    @current_season_loaded = true
#    desktop = Scene.get_desktop()
#    desktop.update() if desktop

  last_match_with_result:->
    for day in @match_dates.reverse()
      return day if day.result


  next_matches:(cnt)->
    Log.trace("next_matches")
    matches = []
    for day in @match_dates
      if !day.result && matches.is_empty()
        matches.push(day)
      else if !day.result && matches.length == cnt - 1
        matches.push(day)
        break

    matches