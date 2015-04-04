# Description:
#   Socket.io client for the100.io chat.
#   Pings users when new games are created.
#
# Dependencies:
#   "cheerio": "^0.19.0"
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
  
  robot.on 'sockets:connection', (socket) ->
    socket.emit 'add user',"guest","Delta Company 837","8705ab8ef76274d9ee683a1d890db6d8","r"
  
  robot.on 'sockets:new message', (socket, msg, data) ->
    username = data.username
    time = data.time
    message = data.message
    link = ""
    link = data.link if data.link != undefined
    
    #robot.messageroom "general", "#{username} created a game! #{link}" if message.match()
    robot.messageRoom "the100chat", "#{username}: #{time}-- #{message}"