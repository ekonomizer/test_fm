class window.Baron

  init:->

  @create:(params)->
    Log.trace(params.root)
    scroll = baron({
        root: params.root#'#content',
        scroller: '.scroller',
        bar: '.scroller__bar',
        barOnCls: 'baron'
        pause: .02,
    })

    scroll_update = ->
      Log.trace('@@@@@@@@@@@@@@@@')
      scroll.update()

    on_click = ->
      setTimeout(scroll_update, 100)

    $(params.root).click(on_click)
    for elem in params.click_elems
      Log.trace(params.root + ' ' + elem)
      $(params.root + ' ' + elem).click(on_click)

    return scroll

