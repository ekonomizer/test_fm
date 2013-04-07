class window.AuthWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#auth_window")
    @description = $("#auth_window #description")
    @description.text(window.texts.auth_window_description)
    @title = $("#auth_window #lable center")
    @title.text(window.texts.auth_window_title)

    @choise_text = $("#auth_window #greetings")
    @choise_text.html(window.texts.auth_window_title2)

    @button_next = $("#auth_window #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)

    @coach_box = $("#auth_window #first_box img")
    @boss_box = $("#auth_window #second_box img")
    @coach_box.click(@on_img_box_click)
    @boss_box.click(@on_img_box_click)

  on_next_button_click:=>
    if window.init_params && window.init_params.manager
      @close_window(@after_auth_window_close)
      #window.scene.bottom_menu.visible(true)
    else
      @description.text(window.texts.need_choise)
      @description.addClass('text_warninig')

  after_auth_window_close:->
    WindowsManager.show_window(ChoiceBaseCareerWindow)

  on_img_box_click:(e)=>
    if @description.hasClass('text_warninig')
      @description.removeClass('text_warninig')
      @description.text(window.texts.auth_window_description)

    @coach_box.removeClass('img_button_clicked')
    @boss_box.removeClass('img_button_clicked')
    $("#auth_window #fm_checkbox").attr('checked', true)

    window.init_params = {}
    window.init_params.manager =
    if e.target.alt == 'boss'
      @boss_box.addClass('img_button_clicked')
      'boss'
    else
      @coach_box.addClass('img_button_clicked')
      'coach'




