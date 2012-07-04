# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
updateCountdownString = (remaining) ->
  if remaining > 1 or remaining is 0
    $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.other',
                                count: remaining)
  else if remaining is 1
    $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.one',
                                count: remaining)
  else if remaining is -1
    $(".countdown").text I18n.t('shared.micropost_form.characters_over.one',
                                count: Math.abs(remaining))
  else
    $(".countdown").text I18n.t('shared.micropost_form.characters_over.other',
                                count: Math.abs(remaining))

updateCountdownAttributes = (toRemove, toAdd = null) ->
  for attr in toRemove
    $(".countdown").removeClass attr
  if toAdd
    $(".countdown").addClass toAdd
    if toAdd is "overlimit"
      $("input.btn.btn-large.btn-primary").attr("disabled", "true")
    else
      $("input.btn.btn-large.btn-primary").removeAttr("disabled")

updateCountdown = ->
  remaining = 140 - $("#micropost_content").val().length
  toRemove = ["nearlimit", "almostlimit", "overlimit"]
  if remaining > 19
    updateCountdownAttributes(toRemove)
  if remaining < 20
    toAdd = (toRemove.filter (attr) -> attr is "nearlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  if remaining < 11
    toAdd = (toRemove.filter (attr) -> attr is "almostlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  if remaining < 0
    toAdd = (toRemove.filter (attr) -> attr is "overlimit").toString()
    updateCountdownAttributes(toRemove, toAdd)
  updateCountdownString(remaining)

$(document).ready ->
  $(".countdown").text I18n.t('shared.micropost_form.characters_remaining.other',
                              count: 140)
  $("#micropost_content").change updateCountdown
  $("#micropost_content").keyup updateCountdown
  $("#micropost_content").keydown updateCountdown
  $("#micropost_content").keypress updateCountdown