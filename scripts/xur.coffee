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
    request 'http://www.destinylfg.com/findxur/', (error, response, html) ->
      $ = cheerio.load(html)
      xurweek = $('div.col-xs-12 h2.text-center').first().text()

      items = []
      $('ul.list-unstyled li').slice(0,4).each (i, elem) ->
        items[i] = $(this).text()  
      items = items.join(', ')

      location = $('img.img-responsive').slice(2).attr("src")
      
      #fields = []
      #fields.push
        #title: "Location"
        #value: location
        #short: true
      
      payload =
        message: msg.message
        content:
          text: "*Item's this week are:* #{items}"
          fallback: "Xur - http://www.destinylfg.com/findxur/"
          pretext: "*Xur?*"
          title: "*Xur-* Week of #{xurweek}"
          title_link: "http://www.destinylfg.com/findxur/"
          color: "#DBB84D"
          image_url: location
          mrkdwn_in: ["text", "pretext", "title"]
          #fields: fields
      
      robot.emit 'slack-attachment', payload