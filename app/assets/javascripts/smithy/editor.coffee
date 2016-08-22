window.ace_edit = (id, template_type, name) ->
  name = 'template_content' if !name
  textarea_id = name + '-' + id
  editor_id = name + '_editor-' + id
  $editor = $("##{editor_id}")
  $textarea = $("##{textarea_id}")
  $editor.show();
  $textarea.hide()
  editor = ace.edit(editor_id)
  session = editor.getSession()
  session.setMode("ace/mode/" + template_type)
  if template_type == 'markdown'
    create_ace_toolbar(editor, $editor.attr('data-assets-url'), $editor.attr('data-pages-url'))
    editor.renderer.setShowGutter(false)
  session.setValue($textarea.val())
  session.setTabSize(2)
  session.setUseSoftTabs(true)
  session.setUseWrapMode(true)
  session.on 'change', ->
    $textarea.val(editor.getSession().getValue())
  editor.commands.addCommand({
    name: 'save',
    bindKey: {win: 'Ctrl-S',  mac: 'Command-S'},
    exec: (editor) ->
      $("#"+editor.container.id).closest('form').submit()
    ,
    readOnly: false
  })
  editor.setOptions
    enableBasicAutocompletion: true
    enableSnippets: true
    maxLines: 40
    minLines: 2
  return editor

create_ace_toolbar = (editor, assets_modal_url, pages_modal_url) ->
  $container = $(editor.container)
  $container.closest('.form-wrapper').find('.ace-editor-toolbar').remove()
  $toolbar = $("<ul class='nav ace-editor-toolbar'></ul>").insertBefore($container)
  heading_dropdown = $("
    <li class='dropdown'>
      <a class='dropdown-toggle' data-toggle='dropdown' href='javascript:void(0)' role='button' aria-haspopup='true' aria-expanded='false'><i class='fa fa-header'></i><span class='caret'></span></a>
      <ul class='dropdown-menu'>
      </ul>
    </li>
  ")
  heading_actions = [
    $("<a href='javascript:void(0);' data-command='h1' class='h1'>Heading</a>"),
    $("<a href='javascript:void(0);' data-command='h2' class='h2'>Heading</a>"),
    $("<a href='javascript:void(0);' data-command='h3' class='h3'>Heading</a>"),
    $("<a href='javascript:void(0);' data-command='h4' class='h4'>Heading</a>")
  ]
  actions = [
    $("<a href='javascript:void(0);' data-command='bold'><i class='fa fa-bold'></i></a>"),
    $("<a href='javascript:void(0);' data-command='italic'><i class='fa fa-italic'></i></a>"),
    heading_dropdown,
    $("<a href='javascript:void(0);'><i class='fa fa-link'></i></a>").on('click', -> open_link_selector(pages_modal_url, editor))
    $("<a href='javascript:void(0);'>Image</a>").on('click', -> open_asset_selector(assets_modal_url, editor))
  ]
  for $action in actions
    $toolbar.append($action)
  for $action in heading_actions
    $toolbar.find('ul').append($action)
  $toolbar.find('a').each ->
    if $(this).attr('data-command')
      $(this).on('click', -> edit_selection(editor, $(this).attr('data-command')))
  $toolbar.find('> a, ul > a').wrap("<li></li>")

open_asset_selector = (url, editor) ->
  open_modal url, 'asset_selector_modal', editor, ->
    $modal = $(this)

    $select_button = $modal.find('.btn.select')
    $select_button.on 'click', ->
      selected_assets = window.assets_table_api.rows({ selected: true })
      return if selected_assets.count() == 0
      insert_assets(selected_assets.data(), $modal, editor)

    load_assets_table($select_button)
    assets_table_api.on "select", (e, dt, type, indexes) ->
      $select_button.prop('disabled', !assets_table_api.rows({ selected: true}).any()) if type == 'row'
    assets_table_api.on "deselect", (e, dt, type, indexes) ->
      $select_button.prop('disabled', !assets_table_api.rows({ selected: true}).any()) if type == 'row'

open_modal = (url, name, editor, callback) ->
  if $('#' + name).length > 0
    $('#'+ name).modal('toggle')
  else
    $.get url, (data) ->
      $('<div id="' + name + '" class="modal fade">' + data + '</div>').appendTo('body').modal().one 'shown.bs.modal', callback

open_link_selector = (url, editor) ->
  open_modal url, 'page_selector_modal', editor, ->
    $modal = $(this)
    $form = $modal.find('form')
    $label_field = $form.find('input[name="label"]')

    $label_field.on 'keypress', ->
      $(this).data('custom-text', true)

    $modal.on 'shown.bs.modal', ->
      $label_field.val(editor.getSelectedText()).trigger('keypress') if !editor.selection.isEmpty()
    .trigger('shown.bs.modal')

    $modal.on 'hidden.bs.modal', ->
      $modal.find('form').trigger('reset')

    $url_fields = $form.find('select[name="page"], input[name="url"]')
    $form.find('select[name="type"]').on 'change', (e) ->
      $url_fields.closest('.form-group').addClass('hidden')
      $url_fields.filter('[name="' + e.target.value + '"]').closest('.form-group').removeClass('hidden')
    .change()

    $form.find('select[name="page"]').on 'change', (e) ->
      $label_field.val($(this).find('option:selected').text().replace(/^[- ]+/, '')) if !$label_field.data('custom-text')

    $modal.find('.btn.select').click ->
      $form.submit()

    $form.on 'submit', (e) ->
      form = e.target
      url = (if (form.type.value == "page") then form.page.value else form.url.value)
      label = form.label.value
      link_string = '['+label+']('+url+')'
      link_string = link_string + '{:target="_blank"}' if form.open_in_new_tab.checked
      editor.insert(link_string)
      $modal.modal('toggle')
      editor.focus()
      return false

insert_assets = (asset_rows, $selector_modal, editor) ->
  editor.insert(("!["+name+"]("+path+" '"+name+"')" for [path, preview, name, size, type] in asset_rows).join('\n') + "\n")
  $selector_modal.modal('toggle')
  editor.focus()

edit_selection = (editor, command) ->
  snippetManager = ace.require("ace/snippets").snippetManager
  session = editor.session
  current_row = editor.selection.getRange().start.row
  switch command
    when 'bold'
      snippetManager.insertSnippet(editor, "**${0:$SELECTION}**")
    when 'italic'
      snippetManager.insertSnippet(editor, "*${0:$SELECTION}*")
    when 'h1'
      session.insert({ row: current_row, column: 0 }, '# ')
    when 'h2'
      session.insert({ row: current_row, column: 0 }, '## ')
    when 'h3'
      session.insert({ row: current_row, column: 0 }, '### ')
    when 'h4'
      session.insert({ row: current_row, column: 0 }, '#### ')
  editor.focus()

$ ->
  $('.ace_editor').smithy_editor()
