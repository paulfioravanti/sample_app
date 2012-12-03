# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  if $('body').hasClass('users-controller') and $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url and $(window).scrollTop() > $(document).height() - $(window).height() - 500
        if $('body').hasClass('index-action') or $('body').hasClass('following-action') or $('body').hasClass('followers-action')
          $('.pagination').text(I18n.t('shared.endless_scroll.fetching_users'))
        if $('body').hasClass('show-action')
          $('.pagination').text(I18n.t('shared.endless_scroll.fetching_microposts'))
        $.getScript(url)
    $(window).scroll()