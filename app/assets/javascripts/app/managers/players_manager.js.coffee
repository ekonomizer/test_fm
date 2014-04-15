class window.PlayersManager

  @get:(params)->
    if not @instance?
      @instance = new @
      @instance.init(params)
    @instance


  init:(players)->
    @players_by_clubs = []
    for player in players
      @players_by_clubs[player.user_club_id] ||= []
      @players_by_clubs[player.user_club_id].push(player)

  my_players:->
    Log.trace('my_players')
    @players_by_clubs[window.user_club.user_club_id]