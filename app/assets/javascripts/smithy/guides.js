
$('[data-toggle="remote-load"]').toggle(
  function(e) {
    e.preventDefault();
    var activator = this;
    var remote = $(this).attr("href");
    var target = $(this).attr("data-target");
    $(target).hide();
    $('[data-dismiss="remote-load"]', $(target)).live('click', function(e) {
      e.preventDefault();
      $(activator).click();
    });
    $.ajax($(this).attr("href"), {
      success: function(data) {
        $(target).append($('<div data-type="remote-load"></div>').append(data));
        $(target).slideDown('slow');
      }
    });
  },
  function(e) {
    e.preventDefault();
    target = $(this).attr("data-target");
    $(target).slideUp('slow', function() { $(this).empty() })
  }
);
