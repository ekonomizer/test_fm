class window.ChoiceBaseCareerWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#choice_base_career_window")
    @bonus_text = $("#choice_base_career_window #description")
    @bonus_text .text(window.texts.choice_base_career_default_bonus)
    @title = $("#choice_base_career_window #lable center")
    @title.text(window.texts.choice_base_career_window_title)

    @choise_text = $("#choice_base_career_window #greetings")
    @choise_text.html(window.texts.choice_base_career_window_title2)

    @button_next = $("#choice_base_career_window #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)

    @coach_box = $("#choice_base_career_window #first_box img")
    @boss_box = $("#choice_base_career_window #second_box img")
    @coach_box.click(@on_img_box_click)
    @boss_box.click(@on_img_box_click)

  on_next_button_click:=>
    if window.init_params && window.init_params.base_career
      @close_window(@after_choice_window_close)
    else
      @bonus_text.text(window.texts.need_choise)
      @bonus_text.addClass('text_warninig')

  after_choice_window_close:->
    WindowsManager.show_window(FreeTeamsWindow)

  on_img_box_click:(e)=>
    if @bonus_text.hasClass('text_warninig')
      @bonus_text.removeClass('text_warninig')
      @bonus_text.text(window.texts.auth_window_description)

    @coach_box.removeClass('img_button_clicked')
    @boss_box.removeClass('img_button_clicked')
    $("#choice_base_career_window #fm_checkbox").attr('checked', true)

    window.init_params.base_career =
      if e.target.alt == 'boss'
        @boss_box.addClass('img_button_clicked')
        @change_text(@bonus_text, window.texts.choice_base_career_thief_bonus)
        'thief'
      else
        @coach_box.addClass('img_button_clicked')
        @change_text(@bonus_text, window.texts.choice_base_career_footballer_bonus)
        'footballer'
