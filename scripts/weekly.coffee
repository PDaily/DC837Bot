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
#
# Comments:
    
cheerio = require('cheerio')
request = require('request')

# imageMatcher function to return image URL based on data pulled from page.
imageMatcher = (data) ->
  # Boss image URLs
  askor = 'http://destinynightfall.com/img/bosses/askor.jpg'
  omnigul = 'http://destinynightfall.com/img/bosses/omnigul.jpg'
  phogoth = 'http://destinynightfall.com/img/bosses/phogoth.jpg'
  sekrion = 'http://destinynightfall.com/img/bosses/sekrion.jpg'
  sepiks = 'http://destinynightfall.com/img/bosses/sepiks.jpg'
  valus = 'http://destinynightfall.com/img/bosses/valus.jpg'
  taniks = 'http://blogs-images.forbes.com/insertcoin/files/2015/05/wolves3.jpg'

  return askor if data == 'askor'
  return omnigul if data == 'omnigul'
  return phogoth if data == 'phogoth'
  return sekrion if data == 'sekrion'
  return sepiks if data == 'sepiks'
  return valus if data == 'valus'
  return taniks if data == 'taniks'
  null
    
module.exports = (robot) ->
  # Nightfall  information. Contains a response of the boss, 'skulls' or modifiers, and the reccommended weapons.
  # Web page is downloaded with request, and parsed with cheerio. Text or url hrefs within the selected HTML tags
  # are used for the information.
  # 
  # TODO: Future versions will use Destiny API to pull data. Some data will need to be gathered in advance
  # 
  # http://www.bungie.net/platform/destiny/Advisors/
  #   Will return a JSON object with current information
  #     * nightfallActivityHash - Current weeks nightfall
  #     * heroicStrikeHashes - Current weeks heroic
  #     * dailyChapterHashes - Todays daily mission
  # 
  # www.bungie.net/platform/destiny/Manifest/Activity/<ACTIVITY_HASH>
  #   Will return a JSON object which can be parsed for:
  #     * activiyDescription - Used to match with activity name ex. "The Nexus"
  #     * destinationHash - Used for planet name lookup (placeName) and planet description (placeDescription)
  robot.hear /!+?\b(nightfall)/i, (msg) ->

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
      
      # Cannot make hyperlinks at this time due to Hubot limitations.
      # 
      # Items lookup:
      #   http://www.bungie.net/platform/destiny/Manifest/inventoryItem/<ITEMHASH>
      #   
      # Hash can be plopped into http://www.destinydb.com/items/<ITEMHASH> for easy viewing.
      ### 
      weaponurl = []
      $('.fa-4x a').each (i, elem) ->
        weaponurl[i] = $(elem).attr('href')
        
      output = ''
      i = 0
      while i < weapons.length
        output += '<' + weaponurl[i] + '|' + weapons[i] + '> '
        i += 1
      ###
      
      imageId = $('header').attr('id')
      
      imageUrl = imageMatcher(imageId)
      
      payload =
        message: msg.message
        content:
          text: "*Modifers this week are:* #{modifiers}.\n*Recommended weapons:* are #{weapons}."
          fallback: "Nightfall- http://destinynightfall.com/"
          title: "Nightfall- #{level}"
          title_link: "http://destinynightfall.com/"
          color: "#38a7e2"
          image_url: imageUrl
          mrkdwn_in: ["text", "title"]
      
      robot.emit 'slack-attachment', payload

  # Weekly information. Not too much information needed here. Just level and modifiers.
  robot.hear /!+?\b(weekly)/i, (msg) ->
    
    request 'http://destinytracker.com/destiny/events/', (error, response, html) ->
      
      $ = cheerio.load(html)
      
      level = $('div.panel-body div.media div.media-body h4.media-heading').text()
  
      modifiers = []
      
      $('div.media-body ul').each (i, elem) ->
        modifiers[i] = $('el').text()
      modifiers = modifiers.join(", ")
      
      #msg.send "*The Weekly Heroic is:* #{level}!\n*Modifers this week are:* #{modifiers}\nGet those coins Guardian!"
      msg.send "No good source for this yet. Sorry!"