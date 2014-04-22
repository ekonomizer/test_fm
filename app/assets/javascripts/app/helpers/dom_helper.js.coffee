class window.DomHelper

  @div:(id, content = '')->
    return ('<div id="' + id + '">' + content + '</div>')

  @b:(content = '')->
    return ('<b>' + content + '</b>')