$(document).ready(function() {

  // Support for AJAX loaded modal window.
  // Focuses on first input textbox after it loads the window.
  $('[data-toggle="modal"]').live('click', function(e) {
    e.preventDefault();
    var url = $(this).attr('href');
    if (url.indexOf('#') == 0) {
      $(url).modal('open');
    } else {
      console.log(url);
      $.get(url, function(data) {
        console.log(data);
        $('<div class="modal hide fade">' + data + '</div>').modal();
      }).success(function() { $('input:text:visible:first').focus(); });
    }
  });

});
