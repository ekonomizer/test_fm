class window.LoginWithoutSocialWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @sign_in_mode = false
    @always_on_top = true
    @window = $("#login_without_social_window")
    @title = $("#login_without_social_window #lable")
    @title.html(window.texts.login_without_social_window_log_in)

    @button_next = $("#login_without_social_window #button_next")
    @button_next.html(window.texts.button_in)
    @button_next.click(@on_next_button_click)

    @text_link = $("#sign_in span")
    @text_link.html(window.texts.login_without_social_window_sign_in)
    @text_link.click(@on_switch_form_click)

    @text_link.attr('title', window.texts.need_sign_in)
    @text_link.tooltip()


    @login_input = $("#login")
    @pass_input = $("#password")
    @login_input.attr('placeholder', window.texts.login)
    @pass_input.attr('placeholder', window.texts.pass)
    $('input[placeholder], textarea[placeholder]').placeholder();

    #if window.init_params && window.init_params.manager
    #WindowsManager.get().close_window(LoginWithoutSocialWindow)
    #WindowsManager.get().show_window(AuthWindow)
      #window.scene.bottom_menu.visible(true)
    #else

  on_next_button_click:=>
    if @login_input.val() == '' ||  @pass_input.val() == ''
      @show_alarm_message()
      return
    if @sign_in_mode
      request = {action: 'auth/sign_in', params: {login: @login_input.val(), password: @pass_input.val()}, callback: @on_sign_in}
      window.server.add_request_in_queue_and_call(request)
      #$.getJSON(window.path + 'auth/sign_in', {login: @login_input.val(), password: @pass_input.val()}, @on_sign_in)
    else
      request = {action: 'auth/login', params: {login: @login_input.val(), password: @pass_input.val()}, callback: @on_login}
      window.server.add_request_in_queue_and_call(request)
      #$.getJSON(window.path + 'auth/login', {login: @login_input.val(), password: @pass_input.val()}, @on_login)

  on_sign_in:(e)=>
    if e.signed_in
      window.init_params ||= {}
      window.init_params.login = @login_input.val()
      window.init_params.password = @pass_input.val()
      WindowsManager.get().close_window(LoginWithoutSocialWindow)
      WindowsManager.get().show_window(AuthWindow)
    else
      @play_wrong_animation()

    if e.login_busy
      @login_input.val('')
      @login_input.attr('placeholder', window.texts.login_already_busy)

  on_login:(e)=>
    if e.loged_in
      WindowsManager.get().close_window(LoginWithoutSocialWindow)
      Scene.start_game()
    else
      @play_wrong_animation()

  show_alarm_message:->
    if @login_input.val() == ''
      @login_input.attr('placeholder', window.texts.need_fill_input)
    else
      @pass_input.attr('placeholder', window.texts.need_fill_input)


  reset_hint:->
    content = if @sign_in_mode
      window.texts.need_sign_in
    else
      window.texts.need_login_in
    @text_link.tooltip({
      content: content
    })


  on_switch_form_click:=>
    @change_title()
    @change_next_button_text()
    @change_text_link()
    @sign_in_mode = !@sign_in_mode
    #@title.text.animate({"margin-left": "+=710px"}, "slow", "easeInOutQuart", =>@window.toggle();call_back())

  change_title:->
    @title.fadeOut("fast");
    @title.fadeIn("fast");
    @title.html(
      if @sign_in_mode
        window.texts.login_without_social_window_log_in
      else
        window.texts.login_without_social_window_sign_in
    )
    @reset_hint()

  change_next_button_text:->
    @button_next.fadeOut("fast");
    @button_next.fadeIn("fast");
    @button_next.html(
      if @sign_in_mode
        window.texts.login_without_social_window_log_in
      else
        window.texts.button_ok
    )

  change_text_link:->
    @text_link.fadeOut("fast");
    @text_link.fadeIn("fast");
    @text_link.html(
      if @sign_in_mode
        window.texts.login_without_social_window_sign_in
      else
        window.texts.login_without_social_window_log_in
    )