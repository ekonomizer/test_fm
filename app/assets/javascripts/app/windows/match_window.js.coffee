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
    @drop_down_schems = '#match_window #dropdown_schems'
    @dropdown_positions_container = '#match_window #positions'
    @dropdown_players_container = '#match_window #players'
    @schems_container = '#match_window #schems'
    @selected_players_ids = []
    @selected_positions_ids = []
    @players_drop_downs = []
    @positions_drop_downs = []
    Log.trace('@@@@!!!!!!!!!')
    Log.trace($(@dropdown_players_container).html())
    @html_players = String($(@dropdown_players_container).html())
    @formation = []
    @PLAYERS_IN_CHAMP_MATCH = 11
    @PLAYERS_IN_FRIEND_MATCH = 16

    @POSITIONS = [
      {name: "GK", x: 108, y: 211},
      {name: "SW", x: 108, y: 248},
      {name: "LB", x: 38, y: 285},
      {name: "CB", x: 108, y: 285},
      {name: "RB", x: 178, y: 285},
      {name: "LWB", x: 16, y: 315},
      {name: "DM", x: 108, y: 322},
      {name: "RWB", x: 200, y: 315},
      {name: "LM", x: 38, y: 359},
      {name: "CM", x: 108, y: 359},
      {name: "RM", x: 178, y: 359},
      {name: "LW", x: 16, y: 433},
      {name: "AM", x: 108, y: 396},
      {name: "RW", x: 200, y: 433},
      {name: "SS", x: 108, y: 433},
      {name: "CF", x: 108, y: 470}]

    @SCHEMS = [
'6-4-0'
5-5-0
5-4-1
5-3-2
5-2-3
5-1-4
4-6-0
4-5-1
4-4-2
4-3-3
4-2-4
3-6-1
3-5-2
3-4-3
3-3-4
]



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
      @init_drop_downs_schems()
      @init_position_circles()
      @first_show = false
    else
      @reset_drop_downs(@players_drop_downs)
      #for drop_down in drop_downs
      #  drop_down.reset_list()

    Log.trace('#######match window show')
    Log.trace_obj(window.players_manager.my_players())
    super

  init_position_circles:->
    for position_obj in @POSITIONS
      $(DomHelper.div(position_obj.name, position_obj.name)).addClass( "circle_position" ).css({bottom: position_obj.y, left: position_obj.x}).appendTo(@schems_container).toggle()

  on_change:(e, dropdown)=>
    #dropdown.obj.selectlabel[0].textContent = '4444')
    new_selected_player_id = e.attr('data-value')

    previus_selected_player_id = $(e).parent().parent().find('input').val()
    @selected_players_ids.push(new_selected_player_id)
    @selected_players_ids.unique()

    @remove_new_selected_player_li(new_selected_player_id)
    if previus_selected_player_id != '-1'
      @selected_players_ids.splice(@selected_players_ids.indexOf(previus_selected_player_id))
      @add_previus_selected_player_li(previus_selected_player_id)

    Log.trace('$$$$$')
    Log.trace(new_selected_player_id)
    Log.trace(previus_selected_player_id)
    Log.trace_obj(window.players_manager.player_by(parseInt(new_selected_player_id)))
    player = window.players_manager.player_by(parseInt(new_selected_player_id))
    dropdown.obj.selectlabel[0].textContent = window.texts.strength + '-' + player.strength + ' ' + player.last_name


  on_pos_change:(e, dropdown)=>
    new_selected_player_id = e.attr('data-value')
    previus_selected_player_id = $(e).parent().parent().find('input').val()
    @selected_positions_ids.push(new_selected_player_id)
    @selected_positions_ids.unique()

    @remove_new_selected_positions_li(new_selected_player_id)
    if previus_selected_player_id != '-1'
      Log.trace('NOT -1@@@@')
      @selected_positions_ids.splice(@selected_positions_ids.indexOf(previus_selected_player_id))
      @add_previus_selected_position_li(previus_selected_player_id)

    @update_position_circles()

  update_position_circles:->
    for position_obj in @POSITIONS
      circle = $(@schems_container + ' #'+position_obj.name)
      visible_now = circle.is(':visible')
      position_selected =  (@selected_positions_ids.indexOf(@POSITIONS.indexOf(position_obj).toString()) != -1)
      circle.toggle() if (position_selected && !visible_now) || (!position_selected && visible_now)

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
          for attr of previus_player.position
            position = attr
          previus_player_html.children('span').html(window.texts.strength + '-' + previus_player.strength + " " +  previus_player.last_name + ', ' + position)
          previus_player_html.insertBefore(child)
          break

    @reset_drop_downs(@players_drop_downs)

  add_previus_selected_position_li:(player_id)->
    Log.trace('@add_previus_selected_position_li')
    for container in $(@dropdown_positions_container).children()
      for child in $(container).children('ul').children('li')
        child_player_id = $(child).attr('data-value')

        if parseInt(player_id) < parseInt(child_player_id)
          previus_player_html = $(child).clone()
          previus_player_html.attr('data-value', player_id)
          previus_player_html.children('span').html(@POSITIONS[parseInt(player_id)].name)
          previus_player_html.insertBefore(child)
          break

    @reset_drop_downs(@positions_drop_downs)

  remove_new_selected_player_li:(player_id)->
    Log.trace('@remove_new_selected_player_li')
    for child in $(@dropdown_players_container + ' ul').children()
      child_player_id = $(child).attr('data-value')
      if child_player_id == player_id
        child.remove()

    @reset_drop_downs(@players_drop_downs)

  remove_new_selected_positions_li:(position_id)->
    Log.trace('@remove_new_selected_position_li')
    for child in $(@dropdown_positions_container + ' ul').children()
      child_position_id = $(child).attr('data-value')
      if child_position_id == position_id
        child.remove()

    @reset_drop_downs(@positions_drop_downs)


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
      @positions_drop_downs.push(drop_down.dropdown({onOptionSelect: @on_pos_change}))

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

  init_drop_downs_schems:->
    Log.trace('init_drop_downs_players')
    drop_downs = []
    drop_downs.push($(@drop_down_schems))
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
      next_option.html(@POSITIONS[i].name)

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
      for attr of player.position
        position = attr
      next_option.html(window.texts.strength + '-' + player.strength + " " +  player.last_name + ', ' + position)
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
