$("form#new_page_content .page_content_block").click ->
  $('#page_content_content_block_type').val($(this).attr('data-content_block'))
  $('form#new_page_content').submit()

$('.pageContent .pageContent-heading a[data-toggle="collapse"]').click (e) ->
  e.preventDefault()
  e.stopPropagation()
  $(this).parent().siblings('.pageContent-fields').collapse('toggle')

# $ ->
#   $('.pageContent-fields').collapse('hide')