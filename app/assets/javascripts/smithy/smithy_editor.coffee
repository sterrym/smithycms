do($ = window.jQuery, window) ->
  $.fn.extend smithy_editor: (option) ->
    @each ->
      $this = $(this)
      [id, type, name] = [$this.data('id'), $this.data('type'), $this.data('name')]
      return unless id && type && name
      ace_edit id, type, name
