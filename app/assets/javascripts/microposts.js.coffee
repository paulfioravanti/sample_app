# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateCountdown = ->
  remaining = 140 - $("#micropost_content").val().length
  $(".remaining, .countdown").addClass "overlimit" if remaining < 0
  $(".remaining, .countdown").removeClass "overlimit" if remaining >= 0
  $(".countdown").text remaining

$(document).ready ->
  updateCountdown()
  $("#micropost_content").change updateCountdown
  $("#micropost_content").keyup updateCountdown