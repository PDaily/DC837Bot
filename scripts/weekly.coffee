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
#   !nightfall - Requests this weeks Nightfall
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
      imageMatcher = (data) ->
        # Boss image URLs
        askor = 'http://destinynightfall.com/img/bosses/askor.jpg'
        omnigul = 'http://destinynightfall.com/img/bosses/omnigul.jpg'
        phogoth = 'http://destinynightfall.com/img/bosses/phogoth.jpg'
        sekrion = 'http://destinynightfall.com/img/bosses/sekrion.jpg'
        sepiks = 'http://destinynightfall.com/img/bosses/sepiks.jpg'
        valus = 'http://destinynightfall.com/img/bosses/valus.jpg'
        
        return aksor if data == 'askor'
        return omnigul if data == 'omnigul'
        return phogoth if data == 'phogoth'
        return sekrion if data == 'sekrion'
        return sepiks if data == 'sepiks'
        return valus if data == 'valus'
        null
      
      imageId = $('header').attr('id')
      
      imageUrl = imageMatcher(imageId)
      
      payload =
        message: msg.message
        content:
          text: "Modifers this week are: #{modifiers}.\nRecommended weapons are #{weapons}."
          fallback: "Nightfall- http://destinynightfall.com/"
          title: "Nightfall- #{level}"
          title_link: "http://destinynightfall.com/"
          color: "#38a7e2"
          image_url: imageUrl
          mrkdwn_in: ["text", "title"]
      
      robot.emit 'slack-attachment', payload
      
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