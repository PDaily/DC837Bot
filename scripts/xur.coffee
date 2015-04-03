# Description:
#   Xur command to find his location, items for sale and pricing
#
# Dependencies:
#   "cheerio": "^0.19.0"
#   "request": "^2.54.0"
#
# Configuration:
#   None required
#
# Commands:
#   !xur - Requests Xur inventory & prices, location.
#
# Authors:
#   pDaily

module.exports = (robot) ->
  
  robot.hear /!+?\b(xur)/i, (msg) ->
    
    cheerio = require('cheerio')
    request = require('request')
    request 'http://xurday.com/', (error, response, html) ->
      
      $ = cheerio.load(html)
      
      location = $('div.slide-out-div center p').text()
      
      msg.send "#{location}\nThat's all you get for now."