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


  load_clubs_by_ids:(ids, callback)->
    ids = [ids] unless ids.isArray
    @clubs_on_load_callback = callback

    for id in ids
      unless @clubs[id]
        start_loading = true
        @last_load_club_ids = id
        $.getJSON(window.path + 'json_items/clubs/'+id.toString()+'.json', {}, @club_loaded)

      callback(@clubs) unless start_loading

  #{"id":1,"name_ru":"Милан","name_en":"Милан","city_id":"1","country_id":"20"}
  club_loaded:(e)=>
    @clubs[e.id] = e
    @clubs_on_load_callback(@clubs) if @last_load_club_ids == e.id



  load_countries_by_ids:(ids, callback)->
    ids = [ids] unless ids.isArray
    @countries_on_load_callback = callback

    for id in ids
      unless @countries[id]
        start_loading = true
        @last_load_country_ids = id
        $.getJSON(window.path + 'json_items/countries/'+id.toString()+'.json', {}, @country_loaded)

      callback(@countries) unless start_loading

  #{"id":4,"name_ru":"Англия","name_en":"England","league_id":1,"divisions":3}
  country_loaded:(e)=>
    @countries[e.id] = e
    @countries_on_load_callback(@countries) if @last_load_country_ids == e.id