class window.FreeTeamsWindow extends BaseWindow

  constructor:->
    @init()

  init:->
    @window = $("#free_teams_window")
    @scrollable_div = '#jp-container'
    @html = '<li class="ui-widget-content">Item 1</li>
    				<li class="ui-widget-content">Item 2</li>
    				<li class="ui-widget-content">Item 3</li>
    				<li class="ui-widget-content">Item 4</li>
    				<li class="ui-widget-content">Item 5</li>
    				'
    $('#jp-container ol').html(@html)
    @title = $("#free_teams_window #lable center")
    @title.text(window.texts.free_teams_window_title)
    @greetings = $("#free_teams_window #greetings")
    @greetings.text(window.texts.free_teams_window_choice_club)

    @error_text = $("#free_teams_window #description")
    #@error_text.text(window.texts.choice_base_career_default_bonus)

    @button_next = $("#free_teams_window #button_next")
    @button_next.html(window.texts.next)
    @button_next.click(@on_next_button_click)
    $.getJSON('http://localhost/users/test_json', {}, (json)-> alert(json['user']))

  on_next_button_click:=>
    if window.init_params && window.init_params.user_club
      @close_window(@after_choice_window_close)
    else
      @error_text.text(window.texts.need_choise_club)
      @error_text.addClass('text_warninig')





  get_scrollable_div:->
    @scrollable_div


