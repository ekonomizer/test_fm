###
  window.onload = (function() {   // когда загрузится вся страница
  VK.init(function() {    // инициализируем Vk API

  // узнаём flashVars, переданные приложению GET запросом. Сохраняем их в переменную flashVars
  var parts=document.location.search.substr(1).split("&");
  var flashVars={}, curr;
  for (i=0; i<parts.length; i++) {
  curr = parts[i].split('=');
  // записываем в массив flashVars значения. Например: flashVars['viewer_id'] = 1;
  flashVars[curr[0]] = curr[1];
  }

  // получаем viewer_id из полученных переменных
  var viewer_id = flashVars['viewer_id'];
  alert(flashVars);

  // выполняем запрос получения профиля
  VK.api("getProfiles", {uids:viewer_id,fields:"photo_big"}, function(data) {
  // обрабатываем полученные данные
  // выводим имя и фамилию в блок user_info
  document.getElementById('user_info').innerHTML = data.response[0].first_name + ' ' + data.response[0].last_name + '<br />';
  // создаем img, для отображения аватарки
  var image=document.createElement('img');
  // из полученных данных берем ссылку на фото
  image.src=data.response[0].photo_big;
  // добавляем img в блок user_info
  user_info.appendChild(image);
  });

  });
  });
###
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class window.User

  # user_data {"club_id"=>"151", "manager"=>"coach", "base_career"=>"footballer"}
  constructor:(user_data)->
    @init()
    @last_name = 'Горелов'
    @first_name = "Андрей"
    @data = if user_data
      {manager: user_data.manager, club_id: user_data.club_id, base_career: user_data.base_career, club_id: user_data.club_id, division: user_data.division }
    else
      {}

    if @data.club_id
      @data.club = {}
      @data.club.coins = user_data.coins
      @data.country = {}
      ItemsManager.get().load_clubs_by_ids(@data.club_id, @on_club_item_loaded)

  init:->
    window.social_api.get_profiles(window.config.user_id(), @on_profiles_load)

  on_profiles_load:(data)->
    @last_name = data[0].last_name
    @first_name = data[0].first_name
    @photo_url = data[0].photo


  on_club_item_loaded:(clubs)=>
    coins = @data.club.coins
    @data.club = clubs[@data.club_id]
    @data.club.coins = coins
    ItemsManager.get().load_countries_by_ids(@data.club.country_id, @on_country_item_loaded)

  is_coach:->
    @data.manager == "coach"

  on_country_item_loaded:(countries)=>
    @data.country = countries[@data.club.country_id]
    desktop = Scene.get_desktop()
    desktop.update() if desktop

  Object.defineProperties @prototype,
    club:
      get: -> @data.club

  Object.defineProperties @prototype,
    country:
      get: -> @data.country

