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

class window.BottomMenu extends BaseWindow

  constructor:->
    @init()
    $(document.body).removeClass("no_js")
    $(document).bind("mousemove", @on_mouse_move)

  init:->
    @proximity = 80
    #css also needs changing to compensate with size
    @iconSmall = 48
    @iconLarge = 88
    @iconDiff = @iconLarge - @iconSmall
    @mouseX = 0
    @mouseY = 0
    @window = $("#dock")
    @animating = false
    @redrawReady = false
    @update()
    @init_click_handlers()


  init_click_handlers:->
    $('#b_m_address').click(@on_address_click)
    $('#b_m_band').click(@on_band_click)
    $('#b_m_calendar').click(@on_calendar_click)


  on_address_click:=>
    windows_manager = WindowsManager.get()
    windows_manager.show_window(AuthWindow)

  on_band_click:=>
    #alert('2')

  on_calendar_click:=>
    #alert('3')

  update:->
    @visible(true)

  distance:(x0, y0, x1, y1)->
    xDiff = x1-x0;
    yDiff = y1-y0;
    Math.sqrt(xDiff*xDiff + yDiff*yDiff)

  on_mouse_move:(e)=>
    if @window.is(":visible")
      @mouseX = e.pageX;
      @mouseY = e.pageY;
      @redrawReady = true;
      @registerConstantCheck()

  registerConstantCheck:->
    if (!@animating)
      @animating = true
      window.setTimeout(@callCheck, 15)

  callCheck:=>
    @window.find("li").each((i,val)=>
      @resizeIcons(val))

    @animating = false

    if @redrawReady
      @redrawReady = false
      @registerConstantCheck()

  resizeIcons:(val)->
    #find the distance from the center of each icon
    centerX = $(val).offset().left + ($(val).outerWidth()/2.0)
    centerY = $(val).offset().top + ($(val).outerHeight()/2.0)

    dist = @distance(centerX, centerY, @mouseX, @mouseY)

    #determine the new sizes of the icons from the mouse distance from their centres
    newSize =  (1 - Math.min(1, Math.max(0, dist/@proximity))) * @iconDiff + @iconSmall
    $(val).find("a").css({width: newSize})
