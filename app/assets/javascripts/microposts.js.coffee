# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

updateCountdown = ->
  remaining = 140 - $("#micropost_content").val().length
  if remaining > 19
    $(".remaining, .countdown").removeClass "nearlimit"
    $(".remaining, .countdown").removeClass "overlimit"
    $(".remaining, .countdown").removeClass "almostlimit"
    $("input.btn.btn-large.btn-primary").removeAttr("disabled")
  if remaining < 20
    $(".remaining, .countdown").removeClass "overlimit"
    $(".remaining, .countdown").removeClass "almostlimit"
    $(".remaining, .countdown").addClass "nearlimit"
    $("input.btn.btn-large.btn-primary").removeAttr("disabled")
  if remaining < 11
    $(".remaining, .countdown").removeClass "overlimit"
    $(".remaining, .countdown").removeClass "nearlimit"
    $(".remaining, .countdown").addClass "almostlimit"
    $("input.btn.btn-large.btn-primary").removeAttr("disabled")
  if remaining < 0
    $(".remaining, .countdown").removeClass "nearlimit"
    $(".remaining, .countdown").removeClass "almostlimit"
    $(".remaining, .countdown").addClass "overlimit"
    $("input.btn.btn-large.btn-primary").attr("disabled", "true")
  $(".countdown").text remaining

$(document).ready ->
  $(".countdown").text 140
  $("#micropost_content").change updateCountdown
  $("#micropost_content").keyup updateCountdown
  $("#micropost_content").keydown updateCountdown
  $("#micropost_content").keypress updateCountdown