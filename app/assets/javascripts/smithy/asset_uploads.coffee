$(document).on 'click', '#choose-files', (e) ->
  $(this).after($('<input type="file" id="choose-files-input" multiple>').hide()) if $('#choose-files-input').length == 0
  $('#choose-files-input').click()

$(document).on 'change', '#choose-files-input', (e) ->
  if this.files.length
    $.each this.files, (i, file) ->

      # Create a new form for the file upload
      new_id  = new Date().getTime();
      $('#asset-upload-table').append copy_blueprint($('#asset_file_fields_blueprint').html(), new_id)

      $form = $("form##{new_id}")
      input = $form.find('input[type=file]')[0]

      # Load the preview image
      generate_preview_img file, (img_data) ->
        preview_image = "<img src=\"#{ img_data }\" />"
        $form.find('.preview').html(preview_image)
      $form.find('.progress').after("<span>#{ formatFileSize(file.size) }</span>")

      # Attach event handlers to watch progress
      $(document).on "upload:start", "form##{new_id}", (e) ->
        $(this).find("input[type=submit]").attr("disabled", true)
      $(document).on "upload:progress", "form##{new_id}", (e) ->
        progress = parseInt(e.originalEvent.detail.loaded / e.originalEvent.detail.total * 100, 10)
        $(this).find('.progress-bar').css('width', "#{progress}%").attr('aria-valuenow', progress)
      $(document).on "upload:success", "form##{new_id}", (e) ->
        $(this).find("input[type=submit]").removeAttr("disabled") if !$(this).find("input.uploading").length
        $(this).css('color', 'green')
      $(document).on "upload:failed", "form##{new_id}", (e) ->
        $(this).css('color', 'red').append("<p>Something went wrong, please check your connection and try again</p>")

      # Finally, start the upload
      window.refileUpload input, file


generate_preview_img = (file, callback) ->
  reader = new FileReader()
  reader.onload = (e) ->
    callback(e.target.result)
  reader.readAsDataURL(file)

copy_blueprint = (blueprint, new_id) ->
  # Make a unique ID for the new child
  regexp  = new RegExp('new_file', 'g');
  content = blueprint.replace(regexp, new_id)

formatFileSize = (bytes) ->
  if (typeof bytes != 'number')
    return ''
  if (bytes >= 1000000000)
    return (bytes / 1000000000).toFixed(2) + ' GB'
  if (bytes >= 1000000)
    return (bytes / 1000000).toFixed(2) + ' MB'
  (bytes / 1000).toFixed(2) + ' KB'