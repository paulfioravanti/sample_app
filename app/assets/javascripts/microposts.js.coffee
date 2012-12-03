# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# updateCountdownString = (remaining) ->
#   if remaining > 1 or remaining is 0
#     $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.other',
#                                 count: remaining)
#   else if remaining is 1
#     $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.one',
#                                 count: remaining)
#   else if remaining is -1
#     $(".countdown").text I18n.t('shared.micropost_form.characters_over.one',
#                                 count: -remaining)
#   else
#     $(".countdown").text I18n.t('shared.micropost_form.characters_over.other',
#                                 count: -remaining)

# takeFromCollection = (collection, className) ->
#   (collection.filter (attr) -> attr is className).toString()

# updateCountdownAttributes = (remaining) ->
#   toRemove = ["nearlimit", "almostlimit", "overlimit"]
#   if remaining < 20
#     toAdd = takeFromCollection(toRemove, "nearlimit")
#   if remaining < 11
#     toAdd = takeFromCollection(toRemove, "almostlimit")
#   if remaining < 0
#     toAdd = takeFromCollection(toRemove, "overlimit")

#   if toAdd isnt null
#     for attr in toRemove
#       $(".countdown").removeClass attr
#     $(".countdown").addClass toAdd
#   if toAdd is "overlimit"
#     $("input.btn.btn-large.btn-primary").attr("disabled", "true")
#   else
#     $("input.btn.btn-large.btn-primary").removeAttr("disabled")

# updateCountdown = ->
#   remaining = 140 - $("#micropost_content").val().length
#   updateCountdownString(remaining)
#   updateCountdownAttributes(remaining)

# $ ->
#   if $('body').hasClass('static_pages home')
#     $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.other',
#                                 count: 140)
#     $("#micropost_content").on("change keyup keydown keypress paste drop",
#                                updateCountdown)
#     if ('.pagination').length
#       $(window).scroll ->
#         url = $('.pagination .next_page a').attr('href')
#         if url && $(window).scrollTop() > $(document).height() - $(window).height() - 500
#           $('.pagination').text I18n.t('shared.endless_scroll.fetching_microposts')
#           $.getScript(url)
#       $(window).scroll()
#     # $('.best_in_place').best_in_place().bind "ajax:success", ->
#     #   $(this).closest("li").effect "highlight", {}, 2000