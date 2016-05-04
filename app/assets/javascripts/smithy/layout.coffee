setLayoutHeight = ->
  $('#content.with-sidebar').css('min-height', $('#side').prop('scrollHeight') - $('#main').height() - 48)
  $('#side').css('max-height', $(window).height()).affix('checkPosition')

$ ->
  $('#side').affix
    offset:
      top: ->
        this.top = $('.navbar').outerHeight(true)
  setLayoutHeight()

$(window).on 'load resize', (e) ->
  setLayoutHeight()