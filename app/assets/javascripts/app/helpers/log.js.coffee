class window.Log

  init:(name = "unknown")->


  @trace:(string, color = null)->
    color ||= 'green'
    console.log('%c '+string, "background: #FFF; color: #{color}; font-size: 14px; ")

  @trace_obj:(obj)->
    #console.log('%c '+obj, 'background: #FFF; color: green; font-size: 14px; ')
    console.log obj