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

  # user_data {"club_id"=>"151", "user_club_id"=>"151", "division"=>"1", "coins"=>"100000", "calendar"=>{}, "manager"=>"coach", "base_career"=>"footballer"}
  constructor:(user_data)->
    @init()
    @last_name = 'Горелов'
    @first_name = "Андрей"
    @data = if user_data
      {manager: user_data.manager, base_career: user_data.base_career }
    else
      {}

  init:->
    window.social_api.get_profiles(window.config.user_id(), @on_profiles_load) if window.social_api

  on_profiles_load:(data)->
    @last_name = data[0].last_name
    @first_name = data[0].first_name
    @photo_url = data[0].photo



  is_coach:->
    @data.manager == "coach"


