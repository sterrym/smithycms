$("form#new_page_content .page_content_block").click(function() {
  $('#page_content_content_block_type').val($(this).attr('data-content_block'));
  $('form#new_page_content').submit();
});
