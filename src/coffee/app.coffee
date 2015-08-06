showCharm = (id)->
  charm = $("#"+id+"-charm").data("charm")
  if charm.element.data("opened") is true
    charm.close()
  else
    charm.open()

download = ->
  element = document.createElement('a')

  if window.workspace is undefined
    window.workspace =
      lang: "en"
      sheets: [
        {
          title: "Sample title",
          description: "nothing here..."
          internal:
            positive: "* Some text..."
            negative: "* Some text..."
          external:
            positive: "* Some text..."
            negative: "* Some text..."
        }
      ]

  jsonString = JSON.stringify window.workspace
  href = 'data:application/json;charset=utf-8,' + encodeURIComponent(jsonString)
  element.setAttribute('href', href)
  element.setAttribute('download', "Untitled.swot")
  element.style.display = 'none'
  document.body.appendChild(element)
  element.click()
  document.body.removeChild(element)
  return

showDialog = ->
  dialog = $("#dialog").data('dialog')
  do dialog.open
  return

$ ->

  $.Metro.init()

  # main data object
  window.workspace =
    lang: window.lang
    sheets: [
      {
        title: ( ->
          return $("header.root h1.name")
                    .clone()
                    .children()
                    .remove()
                    .end()
                    .text()
        )()
        description: $("header.root h1.name small").text()
        internal:
          positive: $('.internal.positive .editor').html()
          negative: $('.internal.negative .editor').html()
        external:
          positive: $('.external.positive .editor').html()
          negative: $('.external.negative .editor').html()
      }
    ]

  # container focus and on change processings...
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
      article.html markdown.toHTML editor.getSession().getValue()
      sectionSelector = ".internal, .external"
      updateWorkspace t.closest(sectionSelector), editor.getSession().getValue()
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
    target = $(e.target)
    isNotArticle = target.closest(swotContainers.find('article')).length == 0
    isNotEditor = target.closest(swotContainers.find('.editor')).length == 0
    if isNotArticle and isNotEditor
      swotContainers.removeClass("focused")
    return

  # file upload bind
  handleFileSelect = (e) ->

    file = e.target.files[0]

    if file
      reader = new FileReader()
      reader.onload = (e) ->
        contents = e.target.result
        data = JSON.parse contents
        window.workspace = data
        setSheet(0)
        renderSheetTabs()
        $('.listview-outlook .list').find('.list-content')
          .first().addClass 'active'
        return
      reader.readAsText file

    return
  if window.File && window.FileReader && window.FileList && window.Blob
    $("aside.root input[type='file']").on "change", handleFileSelect
  else
    $("aside.root input[type='file']").closest(".button").hide()

  # file download bind
  $("aside.root .save.button").on "click", download

  # create new and edit
  createNewSheet = (e) ->
    title = $(@).find("input[name='title']").val()
    description = $(@).find("input[name='description']").val()
    return if title.length < 6
    window.workspace.sheets.push
      title: title
      description: description
      internal:
        positive: "* Some text..."
        negative: "* Some text..."
      external:
        positive: "* Some text..."
        negative: "* Some text..."

    dialog = $("#dialog").data('dialog')
    do dialog.close
    do renderSheetTabs
    t = $(@)
    setTimeout ->
      t.find('.input-control').removeClass 'success'
      t.find('input').val('').trigger 'change'
    , 500
    return
  $("form#add-new").on 'submit', createNewSheet

  # input text placeholder fix
  $("form#add-new input[type='text']").on "change blur", ->
    placeholder = $(@).closest('.input-control').children('.placeholder')
    if $(@).val()
      placeholder.hide()
    else
      placeholder.removeAttr('style')
    return

  # aside sheet stuff
  renderSheetTabs = ->
    index = getCurrentSheetIndex()
    if !window.workspace.sheets[index]
      index = 0
    templateObject = $('.list-content.template')
    container = $('.listview-outlook .list').html('')
    for sheet in window.workspace.sheets
      newObj = templateObject.clone().removeClass 'template'
      newObj.children('.list-title').text sheet.title
      newObj.children('.list-subtitle').text sheet.description
      container.append newObj

    container.find('.list-content').eq(index).addClass 'active'
    return

  $('.listview-outlook .list').delegate ".list-content", "click", (e) ->
    $('.listview-outlook .list')
      .find '.list-content'
      .removeClass 'active'
    $(@).addClass 'active'
    setSheet $(@).index()
    return

  $('.listview-outlook .list').delegate ".list-content .delete", "click", (e) ->
    deleteSheet $(@).closest('.list-content').index()
    return

  editTitleSelector = ".list-content .edit-title"
  $('.listview-outlook .list').delegate editTitleSelector, "click", (e) ->
    index = $(@).closest('.list-content').index()
    sheet = window.workspace.sheets[index]
    titleInput = $('form#add-new').find("input[name='title']")
    titleInput.val(sheet.title)
    descriptionInput = $('form#add-new').find("input[name='description']")
    descriptionInput.val(sheet.description)
    dialog = $("#dialog").data('dialog')
    dialog.open()

    dialog.options.onDialogClose = ->
      setTimeout ->
        form.find('.input-control')
          .removeClass 'success'
          .removeClass 'error'
        form.find('input').val('').trigger 'change'
      , 500
      form.unbind 'submit', changeSheetTitles
      form.on 'submit', createNewSheet
      dialog.options.onDialogClose = -> return undefined
      return

    form = $("form#add-new")

    # placeholder fix
    descriptionInput.trigger 'focus'
    titleInput.trigger 'focus'

    changeSheetTitles = (e) ->
      title = titleInput.val()
      if title.length < 6
        return
      sheet.title = title
      sheet.description = descriptionInput.val()

      dialog.close()
      renderSheetTabs()
      setSheet(getCurrentSheetIndex())
      dialog.options.onDialogClose()
      return

    form.unbind 'submit', createNewSheet
    form.on 'submit', changeSheetTitles
    return

  getCurrentSheetIndex = ->
    $('.listview-outlook .list').find('.list-content.active').index()

  # activating current sheet
  setSheet = (index) ->
    index = 0 if index is -1
    sheet = window.workspace.sheets[index]
    $('header.root h1.name').html sheet.title + '&nbsp;' +
      '<small>' + sheet.description + '</small>'
    ace.edit($('.internal.positive .editor')[0])
      .setValue(sheet.internal.positive)
    ace.edit($('.internal.negative .editor')[0])
      .setValue(sheet.internal.negative)
    ace.edit($('.external.positive .editor')[0])
      .setValue(sheet.external.positive)
    ace.edit($('.external.negative .editor')[0])
      .setValue(sheet.external.negative)
    return

  deleteSheet = (index) ->
    if window.workspace.sheets[index]
      window.workspace.sheets.splice(index, 1)
    setSheet(0)
    renderSheetTabs()
    $('.listview-outlook .list').find('.list-content').first().addClass 'active'
    return

  updateWorkspace = (section, markdown) ->
    updateMe = window.workspace.sheets[getCurrentSheetIndex()]
    return if not updateMe
    if section.hasClass 'internal'
      if section.hasClass 'positive'
        updateMe.internal.positive = markdown
      else
        updateMe.internal.negative = markdown
    else
      if section.hasClass 'positive'
        updateMe.external.positive = markdown
      else
        updateMe.external.negative = markdown
    return

  return