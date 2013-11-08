class window.BaseWindow

  constructor:->
    @window = null

  visible:(val)->
    return unless @window
    visble_now = @window.is(':visible')
    @window.toggle() if (visble_now && !val) || (!visble_now && val)

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

  show:->
    @visible(true)
    @scroll_left()#.appendTo("#windows")
    @scroll_center(@window_sliding_animate)
    new Scrollbar(@get_scrollable_div()) if @get_scrollable_div()

  close:->
    @scroll_right(@window_sliding_animate_and_hide)#.prependTo("#windows")

  scroll_left:(animate_method = null)->
    return @window.position({
      my: "right center",
      at: "left center",
      of: "#windows",
      collision: "none",
      using: animate_method
    })

  scroll_right:(animate_method = null)->
    return @window.position({
      my: "left center",
      at: "right center",
      of: "#windows",
      collision: "none",
      using: animate_method
    });

  scroll_center:(animate_method = null)->
    return @window.position({
      my: "center center",
      at: "center center",
      of: "#windows",
      using: @window_sliding_animate
    });

  window_sliding_animate:(to)=>
    $(this).stop(true, false).animate(to, "slow", "easeInOutQuart")

  window_sliding_animate_and_hide:(to)=>
    $(this).stop(true, false).animate(to, "slow", "easeInOutQuart")


  play_wrong_animation:->
    #@window.effect("shake");
    options = {
      direction: 'left',
      distance: 10,
      times: 2
      }
    left =
      if @window.position().left > parseInt(@window.css('margin-left'))
        @window.position().left
      else
        @window.css('margin-left')
    @window.css({'margin-left': left}).effect('shake' , options , 75)