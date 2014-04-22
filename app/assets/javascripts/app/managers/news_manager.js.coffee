class window.NewsManager

  @get:(params)->
    if not @instance?
      @instance = new @
      @instance.init(params)
    @instance


  init:(params)->
    @news_queue = []
    @add_news(window.texts.greetings_news_label, window.texts.greetings_news_content) if window.server_params.is_new_user
    @add_news(window.texts.joke_label, window.texts.joke_content)

  add_news:(label, content)->
    @news_queue.push({label: label, content: content})


