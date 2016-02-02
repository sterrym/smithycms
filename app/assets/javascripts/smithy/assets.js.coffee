$ ->
  load_assets_table()

window.load_assets_table = ->
  return if $('#assets').length == 0
  $select_all_checkbox = $('#assets_table_select_all')
  $delete_selected_button = $('#delete_selected_assets')

  $('#assets').DataTable {
    select: true
    "responsive": true,
    "serverSide": true,
    "processing": true,
    "ajax": $('#assets').attr('data-source'),
    "order": [[2, 'asc']],
    "language": {
      "emptyTable": "No assets have been added yet. Upload files above to create new assets.",
      "processing": "<span>Processing...</span>"
    },
    "dom": 'l<"toolbar">frtip'
  }

  window.$assets_table = $('#assets').dataTable()
  window.assets_table_api = $assets_table.api()

  $('#assets_wrapper').find('.toolbar').append($delete_selected_button.remove())

  assets_table_api.on "select", (e, dt, type, indexes) ->
    $(assets_table_api.rows(indexes).nodes()).find('input[type="checkbox"]').prop('checked', true) if type == "row"
    $delete_selected_button.show() if assets_table_api.rows({ selected: true }).any()
  assets_table_api.on "deselect", (e, dt, type, indexes) ->
    $(assets_table_api.rows(indexes).nodes()).find('input[type="checkbox"]').prop('checked', false) if type == "row"
    $delete_selected_button.hide() unless assets_table_api.rows({ selected: true }).any()

  $(document).on 'click', '#assets_table_select_all', (e) ->
    $checkbox = $(e.target)
    if $checkbox.prop('checked')
      assets_table_api.rows().select()
    else
      assets_table_api.rows().deselect()

  $assets_table.on 'draw.dt', ->
    $(document).trigger('updateCopyLinks')


window.assets_table_add_rows = (rows) ->
  assets_table_api.rows.add(rows).draw()

window.assets_table_delete_rows = () ->
  assets_table_api.draw()
  $select_all_checkbox.prop('checked', false)
  $delete_selected_button.hide()
