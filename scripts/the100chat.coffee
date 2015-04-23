# Description:
#   Socket.io client for the100.io chat.
#   Pings users when new games are created.
#
# Dependencies:
#   "socket.io-client": "^1.3.5"
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
   
  socket.on 'connect', ->
    socket.emit 'add user',"guest","Delta Company 837","8705ab8ef76274d9ee683a1d890db6d8","r" 
    
  socket.on 'disconnect', ->
    robot.messageRoom "the100chat", "I have lost connection to the100.io"
    
  socket.on 'reconnect', ->
    robot.messageRoom "the100chat", "I have reconnected to the100.io"
    
  socket.on 'new message', (data) ->
    # Retrieves lastMessageTime from redis DB. DOES NOT PERSIST BETWEEN REBOOTS.
    lastMessageTime = robot.brain.get('lastMessageTime')
    
    # Message contents
    userName = data.username
    messageTime = new Date(data.time).getTime()
    localeTime = new Date(data.time).toLocaleTimeString()
    message = data.message
    link = data.link if data.link != undefined
    
    # Convert our timestamps to Date objects for later comparison
    lastMessageTimeParsed = new Date(lastMessageTime)
    messageTimeParsed = new Date(messageTime)
    
    # Finally compare times. If messageTime is newer than the last recorded message, post into the chat room.
    if lastMessageTimeParsed < messageTimeParsed
      setTimeout () ->
        robot.messageRoom "the100chat", "#{userName}: #{localeTime}-- #{message}"
      , 1000
      
      robot.brain.set 'lastMessageTime', messageTime