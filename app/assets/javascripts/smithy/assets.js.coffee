$ ->
  load_assets_table()

  $(".asset-selector-toggle").on 'click', (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    if $('#asset_selector_modal').length > 0
      $('#asset_selector_modal').modal('toggle')
    else
      $.get url, (data) ->
        $('<div id="asset_selector_modal" class="modal fade">' + data + '</div>').appendTo('body').modal()
        $select_button = $('#asset_selector_modal').find('.btn.select')
        $select_button.on 'click', ->
          selected_assets = assets_table_api.rows({ selected: true }).data()
          debugger
        load_assets_table($select_button)

load_assets_table = ($select_button) ->
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

  assets_table_api.on 'select', (e, dt, type, indexes) ->
    console.log(type)
    if type == 'row'
      $select_button.attr('disabled', assets_table_api.rows({ selected: true}).size > 0)


window.assets_table_add_rows = (rows) ->
  assets_table_api.rows.add(rows).draw()

window.assets_table_delete_rows = () ->
  assets_table_api.draw()
  $select_all_checkbox.prop('checked', false)
  $delete_selected_button.hide()
