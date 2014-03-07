class window.Desktop

  constructor:->
    @init()

  init:->
    @window = $("#desktop")
    WindowsManager.get().set_window_visible('desktop')
    @club_icon = $("#club_icon")
    @load_club_icon();
    @club_name = $("#club_name")
    @club_name.html(window.texts.club_name)
    @coach_name = $("#coach_name")
    @coach_name.html(window.texts.coach + window.texts.dont_hired)
    @director_name = $("#director_name")
    @director_name.html(window.texts.director + window.texts.dont_hired)
    @user_coins = $("#user_coins")
    @user_coins.html(window.texts.money)


  load_club_icon:->
    img_params = {}
    img_params.alt = "coach"
    img_params.width = "150"
    img_params.src = window.img_path+"boss.jpg"
    img = TagManager.img(img_params)
    @club_icon.html(img)


  update:->
    @club_name.html(window.texts.club_name + window.owner.club.name_ru + ", " + "D" + window.owner.data.division + ", " + window.owner.country.name_ru)
    if window.owner.is_coach()
      @coach_name.html(window.texts.coach + window.owner.last_name + " " + window.owner.first_name)
    else
      @director_name.html(window.texts.director + window.texts.dont_hired)

    @user_coins.html(window.texts.money + window.owner.club.coins)

