class window.TagManager
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

  @img:(params = null)->
    unless 'class' of params
      params.class = 'image'

    if 'width' of params && !('height' of params)
      params.height = params.width

    if !('width' of params) && 'height' of params
        params.width = params.height

    tag = '<img '
    for k, v of params
      tag += k+'="'+v+'" '

    tag + '/>'