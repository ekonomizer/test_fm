class window.Utils

  @parse_url_query:->
    data = {}
    if location.search
      pair = (location.search.substr(1)).split('&')
      for part in pair
        param = part.split('=')
        data[param[0]] = param[1].replace('http:','').replace('https:','')
    data


