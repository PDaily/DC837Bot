# Description:
#   Nightfall command, responds with current event, boss name & reccommended weapons
#
# Dependencies:
#   "cheerio": "^0.19.0"
#   "request": "^2.54.0"
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
  # Nightfall  information. Contains a response of the boss, 'skulls' or modifiers, and the reccommended weapons.
  # Web page is downloaded with request, and parsed with cheerio. Text or url hrefs within the selected HTML tags
  # are used for the information.
  robot.hear /!+?\b(nightfall)/i, (msg) ->
    
    cheerio = require('cheerio')
    request = require('request')
    request 'http://destinynightfall.com/', (error, response, html) ->
      
      $ = cheerio.load(html)
      
      level = $('div.intro-heading').text()
      
      modifiers = []
      
      $('strong').each (i, elem) ->
        modifiers[i] = $(this).text()
      modifiers = modifiers.join(", ")
      
      weapons = []
      
      $('h4.service-heading').each (i, elem) ->
        weapons[i] = $(this).text()
      weapons = weapons.join(", ")
      
      # Cannot make hyperlinks at this time due to Hubot limitations
      # https://github.com/slackhq/hubot-slack/issues/114
      # 
      #weaponurl = []
      #$('.fa-4x a').each (i, elem) ->
      #  weaponurl[i] = $(elem).attr('href')
      #  
      #output = ''
      #i = 0
      #while i < weapons.length
      #  output += '<' + weaponurl[i] + '|' + weapons[i] + '> '
      #  i += 1
      
      msg.send "*This weeks Nightfall is:* #{level}!\n*Modifers this week are:* #{modifiers}\n*Recommended weapons are:* #{weapons}"
      
  robot.hear /!+?\b(weekly)/i, (msg) ->
    msg.send "I haven't learned that one yet!"
  #  cheerio = require('cheerio')
  #  request = require('request')
  #  
  #  request 'http://destinytracker.com/destiny/events/', (error, response, html) ->
  #    
  #    $ = cheerio.load(html)
  #    
  #    level = $('div.panel-body div.media div.media-body h4.media-heading').text()
  #
  #    modifiers = []
  #    
  #    $('div.media-body ul').each (i, elem) ->
  #      modifiers[i] = $('el').text()
  #    modifiers = modifiers.join(", ")
  #    
  #    msg.send "*The Weekly Heroic is:* #{level}!\n*Modifers this week are:* #{modifiers}\nGet those coins Guardian!"