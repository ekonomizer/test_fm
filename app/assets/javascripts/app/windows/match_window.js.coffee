class window.MatchWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#match_window")
    @always_on_top = true
    @first_show = true
    @scrollable_div = $('#match_window #content')

    @close_button = $("#match_window #close_button")
    @close_button.click(@on_close_button_click)
    @drop_down_positions = '#match_window #dropdown_pos'
    @drop_down_players = '#match_window #dropdown_players'
    @dropdown_positions_container = '#match_window #positions'
    @dropdown_players_container = '#match_window #players'
    @selected_players_ids = []
    @players_drop_downs = []
    @positions_drop_downs = []
    Log.trace('@@@@!!!!!!!!!')
    Log.trace($(@dropdown_players_container).html())
    @html_players = String($(@dropdown_players_container).html())
    @formation = []
    @PLAYERS_IN_CHAMP_MATCH = 11
    @PLAYERS_IN_FRIEND_MATCH = 16

    @POSITIONS = ["GK", "SW", "LB", "CB", "RB", "LWB", "DM", "RWB", "LM", "CM", "RM", "LW", "AM", "RW", "SS", "CF"]
    @scroll = Baron.create({root: '#content', click_elems: 'li'})

    #@scrollbar = new Scrollbar('#jp-container2')
#    @scrollable_div.jScrollPane({	showArrows: true })
#    @api = @scrollable_div.data('jsp')
#    Log.trace_obj(@scrollbar)

  show:->
    if @first_show
      @init_choose_position()
      @init_drop_downs()
      @init_players()
      @init_drop_downs_players()
      @first_show = false
    else
      @reset_drop_downs(@players_drop_downs)
      #for drop_down in drop_downs
      #  drop_down.reset_list()


    Log.trace('#######')
    Log.trace_obj(window.players_manager.my_players())
    super



  on_change:(e)=>
    new_selected_player_id = e.attr('data-value')
    previus_selected_player_id = $(e).parent().parent().find('input').val()
    @selected_players_ids.push(new_selected_player_id)
    @selected_players_ids.unique()

    @remove_new_selected_player_li(new_selected_player_id)
    if previus_selected_player_id != '-1'
      @selected_players_ids.splice(@selected_players_ids.indexOf(previus_selected_player_id))
      @add_previus_selected_player_li(previus_selected_player_id)



  add_previus_selected_player_li:(player_id)->
    Log.trace('@add_previus_selected_player_li')
    previus_player = window.players_manager.player_by(parseInt(player_id))
    for container in $(@dropdown_players_container).children()
      for child in $(container).children('ul').children('li')
        child_player_id = $(child).attr('data-value')
        child_player = window.players_manager.player_by(parseInt(child_player_id))

        if previus_player.strength >= child_player.strength
          previus_player_html = $(child).clone()
          previus_player_html.attr('data-value', player_id)
          previus_player_html.children('span').html(previus_player.strength.toString() + ' ' + previus_player.last_name)
          previus_player_html.insertBefore(child)
          break

    @reset_drop_downs(@players_drop_downs)

  remove_new_selected_player_li:(player_id)->
    Log.trace('@remove_new_selected_player_li')
    for child in $(@dropdown_players_container + ' ul').children()
      child_player_id = $(child).attr('data-value')
      if child_player_id == player_id
        child.remove()

    @reset_drop_downs(@players_drop_downs)


  reset_drop_downs:(drop_downs)->
    for drop_down in drop_downs
      drop_down.close()
      drop_down.reset_list()

  init_drop_downs:->
    drop_downs = []
    drop_downs.push($(@drop_down_positions))
    for i in [1...@PLAYERS_IN_CHAMP_MATCH]
      drop_down_clone = $(@drop_down_positions).clone()
      drop_down_clone.attr('id', @drop_down_positions + (i + 1).toString())
      $(@dropdown_positions_container).append(drop_down_clone)
      drop_downs.push(drop_down_clone)

    for drop_down in drop_downs.reverse()
      @positions_drop_downs.push(drop_down.dropdown())

  init_drop_downs_players:->
    Log.trace('init_drop_downs_players')
    drop_downs = []
    drop_downs.push($(@drop_down_players))
    for i in [1...@PLAYERS_IN_CHAMP_MATCH]
      drop_down_clone = $(@drop_down_players).clone()
      drop_down_clone.attr('id', @drop_down_players + (i + 1).toString())
      $(@dropdown_players_container).append(drop_down_clone)
      drop_downs.push(drop_down_clone)

    for drop_down in drop_downs.reverse()
      @players_drop_downs.push(drop_down.dropdown({onOptionSelect: @on_change}))

  init_choose_position:->
    for i in [0...@POSITIONS.size()]
      option = $(@drop_down_positions + ' #pos' + i.toString())
      next_option = option.clone().insertAfter(option)
      next_option.attr('id', 'pos' + (i + 1).toString())
      next_option.attr('selected', false)
      next_option.attr('value', i)
      next_option.html(@POSITIONS[i])

  init_players:->
    Log.trace('init_players')
    i = 0
    #$(@dropdown_players_container).html(@html_players)
    for player in window.players_manager.my_players()
      continue if player.id in @selected_players_ids
      option = $(@drop_down_players + ' #pos' + i.toString())
      next_option = option.clone().insertAfter(option)
      next_option.attr('id', 'pos' + (i + 1).toString())
      next_option.attr('selected', false)
      next_option.attr('value', player.id)
      next_option.html(player.strength + " " +  player.last_name)
      i++


  on_close_button_click:=>
    WindowsManager.get().close_window(MatchWindow)

  on_close_button_click:=>
    new_formations = []
    cnt = 0
    for drop_down in @players_drop_downs
      new_formations.push(@positions_drop_downs[cnt].value() + ':' + drop_down.value())
      cnt += 1
      Log.trace(drop_down.value())
    if @formation.is_empty() || @formation != new_formations
      @send_formation_to_server(new_formations.join(','))

    WindowsManager.get().close_window(MatchWindow)

  send_formation_to_server:(formation)->
    next_match_id = window.calendar.next_matches(1).first().id
    request = {action: 'championships/set_formation', params: {formation: formation, next_match_id: next_match_id}, callback: @on_formation_send }
    window.server.add_request_in_queue_and_call(request)

  on_formation_send:(e)=>
