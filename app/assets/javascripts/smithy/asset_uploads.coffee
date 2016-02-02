$upload_button = $('#choose-files')
$upload_form = $upload_button.closest('form')
$file_input = $('#presigned_upload_field').find('input[type="file"]')
presigned_upload_field_url = $upload_button.attr('data-presigned-upload-field-url')

$upload_button.on 'click', (e) ->
  $file_input.click();

upload_files = (e) ->
  files = e.target.files
  if files.length
    $upload_form.submit()

    # Reset the file input, so that it can be used again
    $.get presigned_upload_field_url, ->
      $file_input = $('#presigned_upload_field').find('input[type="file"]')
      bind_file_input()

    $progress_bar = $($upload_form).append('<div class="progress"><div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0;"></div></div>').find('.progress-bar')
    total_size = 0; (total_size += file.size for file in files)
    total_uploaded = 0

    $(this).find("input[type=submit]").attr("disabled", true)
    $(document).on "upload:success", $upload_form, (e) ->
      total_uploaded += e.originalEvent.detail.file.size
      progress = parseInt(total_uploaded/total_size * 100, 10)
      $progress_bar.css('width', "#{progress}%").attr('aria-valuenow', progress)
      setTimeout((-> $progress_bar.parent().remove()), 2000) !$upload_form.find("input.uploading").length
    $(document).on "upload:failed", $upload_form, (e) ->
      $(this).addClass("upload-failed").append("<p>Something went wrong, please check your connection and try again</p>")

bind_file_input = ->
  $file_input.on 'change', upload_files

bind_file_input()