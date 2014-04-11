class window.ItemsManager
  # We can make private variables!
  #instance = null

  # Static singleton retriever/loader
  @get:->
    if not @instance?
      @instance = new @
      @instance.init()
    @instance


  # Example class method for debugging
  init:(name = "unknown")->
    @clubs = {}
    @countries = {}
    @match_dates = {}
    @load_clubs_queue = []
    @load_match_dates_queue = []
    @load_countries_queue = []


  add_match_dates_in_load_queue:(ids = null, callback = null)->
    Log.trace('add_match_dates_in_load_queue')
    if ids
      Log.trace_obj(ids)
      ids = [ids] unless ArrayHelper.is_array(ids)
      @load_match_dates_queue.push({callback: callback, ids_loaded: 0, ids: ids, action: 'match_dates', items: @match_dates})
    @load_items(@load_match_dates_queue) if @load_match_dates_queue.length == 1

  add_clubs_in_load_queue:(ids = null, callback = null)->
    Log.trace('add_clubs_in_load_queue')
    Log.trace_obj(ids)
    if ids
      ids = [ids] unless ArrayHelper.is_array(ids)
      @load_clubs_queue.push({callback: callback, ids_loaded: 0, ids: ids, action: 'clubs', items: @clubs})
    @load_items(@load_clubs_queue) if @load_clubs_queue.length == 1

  add_countries_in_load_queue:(ids = null, callback = null)->
    Log.trace('add_countries_in_load_queue')
    Log.trace_obj(ids)
    if ids
      ids = [ids] unless ArrayHelper.is_array(ids)
      @load_countries_queue.push({callback: callback, ids_loaded: 0, ids: ids, action: 'countries', items: @countries})
    @load_items(@load_countries_queue) if @load_countries_queue.length == 1

  load_items:(queue)->
    start_loading = false
    for id in queue[0].ids
      Log.trace(id)
      unless queue[0].items[id]
        start_loading = true
        Log.trace('start_loading by: '+"json_items/#{queue[0].action}/"+id.toString()+'.json')
        $.getJSON(window.path + "json_items/#{queue[0].action}/"+id.toString()+'.json', {}, (e)=>@item_loaded(e, queue))

    unless start_loading
      queue[0].callback(queue[0].items)
      queue.splice(0,1)
      @load_items(queue) unless queue.is_empty()

  #{"id":1,"name_ru":"Милан","name_en":"Милан","city_id":"1","country_id":"20"}
  item_loaded:(e, queue)=>
    Log.trace('item_loaded')
    Log.trace_obj(e)
    queue[0].items[e.id] = e
    queue[0].ids_loaded++
    if queue[0].ids_loaded == queue[0].ids.length
      queue[0].callback(queue[0].items)
      queue.splice(0,1)
      @load_items(queue) unless queue.is_empty()





#  load_clubs_by_ids:(ids = null, callback = null)->
#    if ids
#      ids = [ids] unless ArrayHelper.is_array(ids)
#      @load_clubs_queue.push({callback: callback, ids_loaded: 0, ids: ids})
#    @load_clubs(@load_clubs_queue[0].ids) if @load_clubs_queue.length == 1
#
#
#  load_clubs:(ids)->
#    #Log.trace('load_clubs')
#    #Log.trace(ids)
#    start_loading = false
#    Log.trace_obj @clubs
#
#    for id in ids
#      #Log.trace_obj @clubs[id]
#      #Log.trace id
#      unless @clubs[id]
#        start_loading = true
#        #Log.trace('start_loading')
#        $.getJSON(window.path + 'json_items/clubs/'+id.toString()+'.json', {}, @club_loaded)
#
#    unless start_loading
#      @load_clubs_queue[0].callback(@clubs)
#      @load_clubs_queue.splice(0,1)
#      @load_clubs(@load_clubs_queue[0].ids) unless @load_clubs_queue.is_empty()
#
#  #{"id":1,"name_ru":"Милан","name_en":"Милан","city_id":"1","country_id":"20"}
#  club_loaded:(e)=>
#    #Log.trace('club_loaded', 'red')
#    #Log.trace_obj(e)
#    @clubs[e.id] = e
#    @load_clubs_queue[0].ids_loaded++
#    if @load_clubs_queue[0].ids_loaded == @load_clubs_queue[0].ids.length
#      @load_clubs_queue[0].callback(@clubs)
#      @load_clubs_queue.splice(0,1)
#      @load_clubs(@load_clubs_queue[0].ids) unless @load_clubs_queue.is_empty()
#
#
#
#
#
#
#
#
#
#  load_countries_by_ids:(ids, callback)->
#    ids = [ids] unless ArrayHelper.is_array(ids)
#    @countries_on_load_callback = callback
#    @need_load_countries_ids = ids.length
#    @countries_ids_loaded = 0
#
#    for id in ids
#      unless @countries[id]
#        start_loading = true
#        $.getJSON(window.path + 'json_items/countries/'+id.toString()+'.json', {}, @country_loaded)
#
#    callback(@countries) unless start_loading
#
#  #{"id":4,"name_ru":"Англия","name_en":"England","league_id":1,"divisions":3}
#  country_loaded:(e)=>
#    @countries[e.id] = e
#    @countries_on_load_callback(@countries) if @need_load_countries_ids == @countries_ids_loaded