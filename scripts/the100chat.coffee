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

###  
module.exports = (robot) ->
  socket = require('socket.io-client') "https://the100chat.com/"
   
  socket.on 'connect', ->
    socket.emit 'add user',"guest","Delta Company 837","8705ab8ef76274d9ee683a1d890db6d8","r" 
    
  socket.on 'disconnect', ->
    robot.messageRoom "the100chat", "I have lost connection to the100.io"
    
  socket.on 'reconnect', ->
    robot.messageRoom "the100chat", "I have reconnected to the100.io"
    
  socket.on 'new message', (data) ->
    lastMessage = robot.brain.get('lastMessageTime')
    userName = data.username
    messageTime = new Date(data.time).getTime()
    time = new Date(data.time).toLocaleTimeString()
    message = data.message
    link = ""
    link = data.link if data.link != undefined
    
    if lastMessage < messageTime
      robot.messageRoom "the100chat", "#{userName}: #{time}-- #{message}"
      
    robot.brain.set 'lastMessageTime', messageTime
###