showCharm = (id)->
  charm = $("#"+id+"-charm").data("charm")
  if charm.element.data("opened") is true
    charm.close()
  else
    charm.open()

$ ->

  $.Metro.init()

  swotContainers = $('.internal, .external')

  $('.editor').each ->
    t = $(@)
    article = $(@).next('article')
    article.html markdown.toHTML $(@).html()

    editor = ace.edit(@)
    editor.setTheme("ace/theme/github")
    MarkdownMode = ace.require("ace/mode/markdown").Mode
    editor.getSession().setMode(new MarkdownMode())
    editor.getSession().setUseWrapMode(true)
    editor.renderer.setShowGutter(false)
    editor.setOptions
      fontSize: 16
    editor.getSession().on "change", (obj)->
      console.log markdown.toHTML editor.getSession().getValue()
      article.html markdown.toHTML editor.getSession().getValue()
      return
    editor.on "blur", () ->
      t.closest(swotContainers).removeClass("focused")
      return
    return

  swotContainers.find('article').on "click", ->
    swotContainers.removeClass("focused")
    $(@).closest(swotContainers).addClass("focused")
    return

  $('html').on "click", (e) ->
    isNotArticle = $(e.target).closest(swotContainers.find('article')).length == 0
    isNotEditor = $(e.target).closest(swotContainers.find('.editor')).length == 0
    if isNotArticle and isNotEditor
      swotContainers.removeClass("focused")
    return

  return