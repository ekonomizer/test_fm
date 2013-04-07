class window.WindowsManager
  # We can make private variables!
  instance = null

  # Static singleton retriever/loader
  @get:->
    if not @instance?
      instance = new @
      instance.init()

    instance

  # Example class method for debugging
  init:(name = "unknown")->
    #console.log "#{name} initialized"


  @show_window:(name)->
    window = new name()
    window.show_by_horizontal_sliding()
    #$("#"+name).toggle(1000) unless $("#"+name).is(':visible')