class window.BaseWindow

  constructor:->
    @window = null


  visible:(val)->
    return unless @window
    visble_now = @window.is(':visible')
    @window.toggle(1000) if (visble_now && !val) || (!visble_now && val)

  close_window:(call_back)->
    return unless @window
    @window.animate({"margin-left": "+=710px"}, "slow", "easeInOutQuart", =>@window.toggle();call_back())

  show_by_horizontal_sliding:->
    return unless @window
    @window.toggle()
    @window.css("margin-left", "-620px")
    @window.animate({"margin-left": "+=715px"}, "normal", "easeInOutQuart")
    new Scrollbar(@get_scrollable_div()) if @get_scrollable_div()

  change_text:(target, text)->
    target.fadeOut(100, =>target.text(text))
    target.fadeIn(200)

  get_scrollable_div:->
    ''
