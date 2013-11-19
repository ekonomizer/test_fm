class window.DesktopWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#desktop_window")
    @description = $("#desktop #description")
    @description.text(window.texts.desktop_description)
    @title = $("#desktop #lable")
    @title.text(window.texts.desktop_title)

    @choise_text = $("#desktop #greetings")
    @choise_text.html(window.texts.desktop_title2)

    @button_next = $("#desktop #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)

    @coach_box = $("#desktop #first_box img")
    @boss_box = $("#desktop #second_box img")
    @coach_box.click(@on_img_box_click)
    @boss_box.click(@on_img_box_click)

  on_next_button_click:=>
    if window.init_params && window.init_params.manager
      WindowsManager.get().close_window(AuthWindow)
      WindowsManager.get().show_window(ChoiceBaseCareerWindow)
      #window.scene.bottom_menu.visible(true)
    else
      @description.text(window.texts.need_choise)
      @description.addClass('text_warninig')

  after_desktop_close:->
    WindowsManager.show_window(ChoiceBaseCareerWindow)

  on_img_box_click:(e)=>
    if @description.hasClass('text_warninig')
      @description.removeClass('text_warninig')
      @description.text(window.texts.desktop_description)

    @coach_box.removeClass('img_button_clicked')
    @boss_box.removeClass('img_button_clicked')
    $("#desktop #fm_checkbox").attr('checked', true)

    window.init_params ||= {}
    window.init_params.manager =
    if e.target.alt == 'boss'
      @boss_box.addClass('img_button_clicked')
      'boss'
    else
      @coach_box.addClass('img_button_clicked')
      'coach'

