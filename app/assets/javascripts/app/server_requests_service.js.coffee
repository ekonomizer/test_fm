class window.ServerRequestsService

  constructor:->
    @requests = []

  add_request_in_queue_and_call:(params)->
    @requests.push params
    @call_requests(params)

  call_requests:->
    for request in @requests
      request.params.user_id = window.config.user_id()
      request.params.auth_key = window.social_api.flash_vars['auth_key']
      $.getJSON(window.path + request.action, request.params, request.callback)

