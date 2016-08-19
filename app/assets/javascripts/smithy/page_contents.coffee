$("form#new_page_content .page_content_block").click ->
  $('#page_content_content_block_type').val($(this).attr('data-content_block'))
  $('form#new_page_content').submit()

$('.page_content .page_content-heading a[data-toggle="collapse"]').click (e) ->
  e.preventDefault()
  e.stopPropagation()
  $(this).parent().siblings('.page_content-fields').collapse('toggle')

# $ ->
#   $('.page_content-fields').collapse('hide')
