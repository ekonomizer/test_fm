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

  my_players:(need_sort=true, sort_by_pos='')->
    Log.trace('my_players')
    if need_sort
      @players_by_clubs[window.user_club.user_club_id].sort(@sort_function)
    else
      @players_by_clubs[window.user_club.user_club_id]

  player_by:(player_id, user_club_id = null)->
    user_club_id ||= window.user_club.user_club_id
    ids = @players_by_clubs[window.user_club.user_club_id].filter((player)-> player.id == player_id)
    ids.first()

  sort_function:(player_a,player_b)->
    return 1 if player_a.strength < player_b.strength
    return -1 if player_a.strength > player_b.strength
    return 0 if player_a.strength == player_b.strength
