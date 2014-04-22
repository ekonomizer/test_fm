class window.NewsWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#news_window")
    @always_on_top = true
    @news_container = $("#news_container")

    @news_label = $("#news_container .news_label")
    @news_content = $("#news_container .news_content")

    @title = $("#news_window #lable a")
    @title.text(window.texts.news_window_title)
    @close_button = $("#close_button")
    @close_button.click(@on_close_button_click)
    @init_news()

  on_close_button_click:=>
    WindowsManager.get().close_window(NewsWindow)

  on_click:(e)->
    #Log.trace_obj(e.value)
#    Log.trace(e.target.id)
#    Log.trace(e.currentTarget.id)
#    id = e.target.id || e.currentTarget.id
#    $("#" + id + " #news_content").slideDown("slow")



  init_news:->
    @news_container.empty()
    last_label = @news_label
    last_content = @news_content


    news_counter = 0
    for news in NewsManager.get().news_queue
      label_html = last_label.clone()
      label_html.html(news.label)
      content_html = last_content.clone()
      content_html.html(news.content)

      @news_container.append(label_html)
      @news_container.append(content_html)


    @news_container.accordion({event: "click hoverintent", heightStyle: "fill"});


