# Description:
#   Socket.io client for the100.io chat.
#   Pings users when new games are created.
#
# Dependencies:
#   "socket.io-client": "^1.3.5"
#   "hubot.io": "^0.1.3"
#
# Configuration:
#   None required
#
# Commands:
#   None, all automatic.
#
# Authors:
#   pDaily

  
module.exports = (robot) ->
  socket = require('socket.io-client') "https://the100chat.com/"
  messages = ""
  users = []
  connected = false
   
  socket.on 'connect', ->
    socket.emit 'add user',"guest","Delta Company 837","8705ab8ef76274d9ee683a1d890db6d8","r" 
    
  socket.on 'new message', (data) ->
    username = data.username
    time = data.time
    message = data.message
    link = ""
    link = data.link if data.link != undefined
    
    #robot.messageroom "general", "#{username} created a game! #{link}" if message.match()
    robot.messageRoom "the100chat", "#{username}: #{time}-- #{message}"
    