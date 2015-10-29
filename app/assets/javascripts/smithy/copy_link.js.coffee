jQuery ->
  ($ 'body').on "click", ".copy-to-clipboard", (e) ->
    e.preventDefault()
  ($ 'body').on "copy", ".copy-to-clipboard", (e) ->
    e.preventDefault()
    $link = ($ this)
    saved_text = $link.text()
    $link.text 'Copied!'
    setTimeout ->
      $link.text(saved_text)
    , 2000
    # actually do the copying
    e.clipboardData.clearData()
    e.clipboardData.setData "text/plain", ($ this).data('clipboard-text')
