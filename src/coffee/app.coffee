showCharm = (id)->
  charm = $("#"+id+"-charm").data("charm")
  if charm.element.data("opened") is true
    charm.close()
  else
    charm.open()

$ ->
  $.Metro.init()
  return