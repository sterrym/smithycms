$select_all_checkbox = $('#assets_table_select_all')
$delete_selected_button = $('#delete_selected_assets')

$('#assets').DataTable {
  "responsive": true,
  "serverSide": true,
  "processing": true,
  "ajax": $('#assets').attr('data-source'),
  "order": [[2, 'asc']],
  "columnDefs": [
    { "targets": [0,1,5], "searchable": false, "orderable": false },
    { "targets": [1], "className": "preview" }
  ],
  "language": {
    "emptyTable": "No assets have been added yet. Upload files above to create new assets.",
    "processing": "<span>Processing...</span>"
  },
  "dom": 'l<"toolbar">frtip'
}

window.$assets_table = $('#assets').dataTable()
window.assets_table_api = $assets_table.api()

$('#assets_wrapper').find('.toolbar').append($delete_selected_button.remove())

$(document).on 'click', '#assets_table_select_all', (e) ->
  $checkbox = $(e.target)
  $assets_table.find('input.delete').prop('checked', $checkbox.prop('checked'))

$(document).on 'click', '#assets_wrapper input[type="checkbox"]', (e) ->
  if $('#assets_wrapper input[type="checkbox"]:checked').length > 0
    $delete_selected_button.show()
  else
    $delete_selected_button.hide()

$assets_table.on 'draw.dt', ->
  $(document).trigger('updateCopyLinks')

window.assets_table_add_rows = (rows) ->
  assets_table_api.rows.add(rows).draw()

window.assets_table_delete_rows = () ->
  assets_table_api.draw()
  $select_all_checkbox.prop('checked', false)
  $delete_selected_button.hide()
