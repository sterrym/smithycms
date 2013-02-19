$('[data-toggle="remote-load"]').click(function(e) {
  e.preventDefault();
  var activator = this;
  var remote = $(this).attr("href");
  var target = $(this).attr("data-target");
  if ($(target).filter(":empty").length > 0) {
    $(target).hide();
    $.ajax($(this).attr("href"), {
      success: function(data) {
        $(target).append($('<div data-type="remote-load"></div>').append(data));
        $('[data-dismiss="remote-load"]', $(target)).on('click', function(e) {
          e.preventDefault();
          $(activator).click();
        });
        $(target).slideDown('slow');
      }
    });
  } else if ($(target).filter(":hidden").length > 0) {
    $(target).slideDown('slow');
  } else if ($(target).filter(":visible").length > 0) {
    $(target).slideUp('slow');
  }
});
