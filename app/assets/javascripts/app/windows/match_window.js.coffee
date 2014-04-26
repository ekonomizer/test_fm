class window.MatchWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#match_window")
    @always_on_top = true

    @scrollable_div = $('#match_window #content')

    @close_button = $("#match_window #close_button")
    @close_button.click(@on_close_button_click)
    @drop_down = '#dropdown'

    @PLAYERS_IN_CHAMP_MATCH = 14
    @PLAYERS_IN_FRIEND_MATCH = 16
    @POSITIONS = ["CF", "SS", "AM", "RW", "LW", "CM", "RM", "LM", "DM", "RWB", "LWB", "CB", "RB", "LB", "SW", "GK","CF", "SS", "AM", "RW", "LW", "CM", "RM", "LM", "DM", "RWB", "LWB", "CB", "RB", "LB", "SW", "GK"]


    @init_positions()
    #@scrollbar = new Scrollbar('#jp-container2')

    @scrollable_div.jScrollPane({	showArrows: true })
    @api = @scrollable_div.data('jsp')

    Log.trace_obj(@scrollbar)
    $('#dropdown').dropdown()

    @scroll = Baron.create({root: '#content', click_elems: 'li'})

  init_positions:->
    for i in [0...@POSITIONS.size()]
      option = $(@drop_down + ' #pos' + i.toString())
      next_option = option.clone().insertAfter(option)
      next_option.attr('id', 'pos' + (i + 1).toString())
      next_option.attr('selected', false)
      next_option.attr('value', i+1)
      next_option.html(@POSITIONS[i])

#    <option value="1">CF</option>
#    <option value="2">SS</option>
#    <option value="3">LW</option>
#    <option value="4">RW</option>
#    <option value="5">AM</option>
#    <option value="6">LM</option>
#    <option value="7">RM</option>
#    <option value="8">CM</option>
#    <option value="9">LWB</option>
#    <option value="10">RWB</option>
#    <option value="11">DM</option>
#    <option value="12">LB</option>
#    <option value="13">RB</option>
#    <option value="14">CB</option>
#    <option value="15">SW</option>
#    <option value="16">GK</option>


  on_close_button_click:=>
    WindowsManager.get().close_window(MatchWindow)