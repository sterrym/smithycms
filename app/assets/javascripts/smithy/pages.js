$(function() {
  // Support for AJAX loaded modal window.
  // Focuses on first input textbox after it loads the window.
  $("[data-previewtoggle='modal']").on('click', function(e) {
    e.preventDefault();
    var url = $(this).attr('href');
    if (url.indexOf('#') == 0) {
      $(url).modal('open');
    } else {
      $.get(url, function(data) {
        $('<div class="modal fade">' + data + '</div>').modal();
      }).success(function() { $('input:text:visible:first').focus(); });
    }
  });

  $(".page-contents").sortable({
    distance: 20,
    handle: ".handle",
    items: "tr.page_content",
    update: function() {
      $.ajax($(this).attr('data-reorder-href'), {
        data: $(this).sortable("serialize", { key: "order[]" })
      });
    }
  });

  $(".page-list").sortable({
    distance: 20,
    handle: ".handle",
    items: "> li.child",
    update: function() {
      $.ajax("/smithy/pages/order", {
        data: $(".page-list").sortable("serialize", { key: "order[]" })
        // highlight on failure?
        // failure: function(xhr, status, error) {}
      });
    }
  });
});


