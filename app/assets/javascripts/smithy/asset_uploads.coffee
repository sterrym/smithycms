$(document).on 'click', '#choose-files', (e) ->
  $(this).after($('<input type="file" id="choose-files-input" multiple>').hide()) if $('#choose-files-input').length == 0
  $('#choose-files-input').click()

$(document).on 'change', '#choose-files-input', (e) ->
  if this.files.length
    $.each this.files, (i, file) ->
      # for each file, copy the blueprint and have it show up which starts uploading it immediately
      # also, progress bar during upload

# $(document).on "upload:start", "form", (e) ->
#   $(this).find("input[type=submit]").attr("disabled", true)
# $(document).on "upload:complete", "form", (e) ->
#   $(this).find("input[type=submit]").removeAttr("disabled") if !$(this).find("input.uploading").length
