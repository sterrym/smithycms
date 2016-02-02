$upload_button = $('#choose-files')
$upload_form = $upload_button.closest('form')
file_input_selector = '#presigned_upload_field input[type="file"]'
presigned_upload_field_url = $upload_button.attr('data-presigned-upload-field-url')

$progress_bar = $($upload_form).append('<div class="progress" style="display:none;"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0;"></div></div>').find('.progress-bar')

$upload_button.on 'click', (e) ->
  $(file_input_selector).click();

total_uploaded = 0
total_size = 0

upload_files = (e) ->
  total_uploaded = 0
  file_input = e.target
  $file_input = $(file_input)
  files = file_input.files
  if files.length
    total_size = 0; (total_size += file.size for file in files)
    $progress_bar.parent().show()

$(document).on 'change', $upload_form, upload_files
$(document).on "upload:success", $upload_form, (e) ->
  total_uploaded += e.originalEvent.detail.file.size
  progress = parseInt(total_uploaded/total_size * 100, 10)
  $progress_bar.css('width', "#{progress}%").attr('aria-valuenow', progress)
  if !$upload_form.find("input.uploading").length
    $upload_form.submit()
    setTimeout((-> $progress_bar.css('width', "0%").parent().hide()), 2000)
$(document).on "upload:failure", $upload_form, (e) ->
  $(this).addClass("upload-failed").append("<p>Something went wrong, please check your connection and try again</p>")
$(document).on "upload:complete", $upload_form, (e) ->
  console.log("Complete")
  if !$upload_form.find("input.uploading").length
    # Reset the file input, so that it can be used again
    $.get presigned_upload_field_url
