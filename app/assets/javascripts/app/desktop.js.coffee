class window.Desktop

  constructor:->
    @init()

  init:->
    @window = $("#desktop")
    @club_icon = $("#club_icon")
    @load_club_icon();
    @club_icon = $("#club_icon")
    @club_name = $("#club_name")
    @club_name.html(window.texts.club_name)
    @coach_name = $("#coach_name")
    @director_name = $("#director_name")


  load_club_icon:->
    img_params = {}
    img_params.alt = "coach"
    img_params.width = "150"
    img_params.src = window.img_path+"boss.jpg"
    img = TagManager.img(img_params)
    @club_icon.html(img)


  update:->

    #alert(window.owner.data)
    @club_name.html(window.texts.club_name + window.owner.club.name_ru + ", " + "D" + window.owner.data.division + ", " + window.owner.country.name_ru)

