# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /badger/i, (msg) ->
     msg.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  
  robot.hear /me gusta/i, (msg) ->
    msg.send "http://s3.amazonaws.com/kym-assets/entries/icons/original/000/002/252/me-gusta.jpg"

  robot.respond /open the (.*) doors/i, (msg) ->
    doorType = msg.match[1]
    if doorType is "pod bay"
      msg.reply "I'm afraid I can't let you do that."
    else
      msg.reply "Opening #{doorType} doors"

  robot.hear /I like pie/i, (msg) ->
    msg.emote "makes a freshly baked pie"

  lulz = ['lol', 'rofl', 'lmao', '( ͡° ͜ʖ ͡°)']

  robot.hear /lol/i, (msg) ->
      msg.send msg.random lulz

  # For when someone new enters/leaves the channel
  enterReplies = "Welcome to the chatroom! My name is Cortana! If you have any questions, type \'Cortana help\' into the chat window :)"
  leaveReplies = ['Are you still there?', 'Bye!', 'Where did you do?']

  robot.enter (msg) ->
    msg.send enterReplies
  robot.leave (msg) ->
    msg.send msg.random leaveReplies

    
  # It'll get to you eventually?  
  robot.respond /you are a little slow/, (msg) ->
    setTimeout () ->
      msg.send "Who you calling 'slow'?"
    , 60

    
  annoyIntervalId = null
  
  # Start the pain
  robot.respond /annoy me/, (msg) ->
    if annoyIntervalId
      msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
      return

    msg.send "Hey, want to hear the most annoying sound in the world?"
    annoyIntervalId = setInterval () ->
      msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
    , 1000
  
  # Stop the pain
  robot.respond /unannoy me/, (msg) ->
    if annoyIntervalId
      msg.send "GUYS, GUYS, GUYS!"
      clearInterval(annoyIntervalId)
      annoyIntervalId = null
    else
      msg.send "Not annoying you right now, am I?"

  # If anything goes wrong, raise an error to the chat
  robot.error (err, msg) ->
    robot.logger.error "DOES NOT COMPUTE"

    if msg?
      msg.reply "DOES NOT COMPUTE"
