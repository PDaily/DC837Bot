# Description:
#   Nightfall command, responds with current event, boss name & reccommended weapons
#
# Dependencies:
#   "cheerio": "^0.19.0"
#
# Configuration:
#   None required
#
# Commands:
#   !nightfall
#
# Authors:
#   pDaily

module.exports = (robot) ->
  
  robot.hear /!+?\b(nightfall)/i, (msg) ->
    
    cheerio = require('cheerio')
    request = require('request')
    request 'http://destinynightfall.com/', (error, response, html) ->
      $ = cheerio.load(html)
      level = $('div.intro-lead-in').first().text()
      boss = $('div.intro-heading').text()
      modifiers = []
      $('strong').each (i, elem) ->
        modifiers[i] = $(this).text()
        modifiers.join(", ")
      weapons = []
      $('h4.service-heading').each (i, elem) ->
        weapons[i] = $(this).text()
        weapons.join(", ")
      msg.send "*This weeks Nightfall is:* #{level}!\n*Modifers this week are:* #{modifiers}\n*Recommended weapons are:#{weapons}."
      
      