class window.UserClub

  # user_data {"club_id"=>"151", "user_club_id"=>"151", "division"=>"1", "coins"=>"100000", "calendar"=>{}, "manager"=>"coach", "base_career"=>"footballer"}
  constructor:(user_data)->
    @init()
    Log.trace "create user club"
    Log.trace_obj user_data
    @club_id = user_data.club_id
    @user_club_id = user_data.id || user_data.user_club_id
    @division = user_data.division
    @coins = user_data.coins

    if @club_id
      @club = {}
      @country = {}
      ItemsManager.get().add_clubs_in_load_queue(@club_id, @on_club_item_loaded)

  init:->

  on_club_item_loaded:(clubs)=>
    @club = clubs[@club_id]
    ItemsManager.get().add_countries_in_load_queue(@club.country_id, @on_country_item_loaded)

  on_country_item_loaded:(countries)=>
    @country = countries[@club.country_id]
#    desktop = Scene.get_desktop()
#    desktop.update() if desktop

#  Object.defineProperties @prototype,
#    club:
#      get: -> @data.club
#
#  Object.defineProperties @prototype,
#    country:
#      get: -> @data.country

