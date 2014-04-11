class window.DateHelper

  init:()->

  @month:(cnt)->
    month = []
    month[0]="Января";
    month[1]="Февраля";
    month[2]="Марта";
    month[3]="Апреля";
    month[4]="Мая";
    month[5]="Июня";
    month[6]="Июля";
    month[7]="Августа";
    month[8]="Сентября";
    month[9]="Октября";
    month[10]="Ноября";
    month[11]="Декабря";
    return month[cnt]

  @msk_offset:->
    return 4

  @minutes:(cnt)->
    return if cnt > 9
      cnt.toString()
    else
      '0'+cnt.toString()

  @date:(date)->
    #2 апреля, 22:00
    month = @month(date.getMonth())

    day = if @is_today(date)
      'сегодня'
    else
      date.getDate()
    hours = (date.getHours() + @msk_offset()).toString()
    minutes = @minutes(date.getMinutes())
    return day.toString()+' '+month+','+' '+ hours + ':' + minutes

  @is_today:(date)->
    today = new Date()
    return today.getDate() == date.getDate() && today.getMonth() == date.getMonth() && today.getYear() == date.getYear()