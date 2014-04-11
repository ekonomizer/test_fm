class window.UserClubManager

  @get:(params = null)->
    if not @instance?
      @instance = new @
      @instance.init(params)
    @instance


  init:(data = null)->


  init_user_clubs:(data)->
    @user_clubs = []
    for user_data in data
      @user_clubs[user_data.id] = new UserClub(user_data) unless @user_clubs[user_data.id]

  add_user_club:(user_club)->
    @user_clubs[user_club.user_club_id] = user_club unless @user_clubs[user_club.user_club_id]