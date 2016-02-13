# Description:
# Pulls a random gif (optionally limited by tag[s]) from Giphy
#
# Dependencies:
# none
#
# Configuration:
# process.env.HUBOT_GIPHY_API_KEY = <your giphy API key>
# process.env.HUBOT_GIPHY_RATING = 'pg' (y, g, pg, pg-13 or r)
#
# Commands:
# hubot gif me - Get a completely random GIF
# hubot gif me tag 1, "tag 2" - Search for a GIF tagged with "tag 1" and "tag 2"
# hubot giphy - Get a completely random GIF
# hubot giphy tag 1, "tag 2" - Search for a GIF tagged with "tag 1" and "tag 2"
#
# Author:
# Ben Centra

# Key for Giphy API
# Default value is the demo key; please request your own here: http://api.giphy.com/submit
GIPHY_API_KEY = process.env.HUBOT_GIPHY_API_KEY or 'dc6zaTOxFJmzC'

# Content rating to prevent NSFW responses
# Possible values: y, g, pg, pg-13 or r
CONTENT_RATING_LIMIT = process.env.HUBOT_GIPHY_RATING or 'pg'

# Base URL of Giphy API "random" endpoint
# API Docs: https://github.com/Giphy/GiphyAPI#random-endpoint
ENDPOINT_URL_RANDOM = "http://api.giphy.com/v1/gifs/random?api_key=#{GIPHY_API_KEY}&rating=#{CONTENT_RATING_LIMIT}"

# Enable console output for development
DEBUG = process.env.DEBUG or false

# Singleton instance of Giphy class
giphy = null

_debug = ->
  console.log.apply(this, arguments) if DEBUG

class Giphy

  constructor: ->

  createTagsParam: (tagString) ->
    ignoredCharactersRegex = /['",]/g
    whitespaceRegex = /\s/g
    tagString = tagString.trim()
    tagString = tagString.replace ignoredCharactersRegex, ''
    tagString = tagString.replace whitespaceRegex, '+'
    _debug 'tagString', tagString
    tagString

  makeApiCall: (msg, url, callback) ->
    msg.http(url).get() (err, res, body) ->
      if err or res.statusCode isnt 200
        msg.send 'Apologies -- something went wrong looking for your GIF.'
      else
        response = JSON.parse(body).data
        _debug 'response', response
        callback response

  getRandomGif: (msg, tags) ->
    url = ENDPOINT_URL_RANDOM
    if tags
      tagsParam = @createTagsParam tags
      url += "&tag=#{tagsParam}"
    _debug 'url', url
    @makeApiCall msg, url, (response) ->
      if response.image_url
       msg.send response.image_url
      else
        if tags
          msg.send "Apologies -- I couldn't find any GIFs matching '#{tags}'."
        else
          msg.send "Apologies -- I couldn't find any GIFs! This is very strange, indeed."

# Commands to expose to Hubot
module.exports = (robot) ->
  robot.respond /(gif me|giphy)(.*)/i, (msg) ->
    command = msg.match[1]
    _debug 'command', command
    tags = msg.match[2]
    _debug 'tags', tags
    giphy = giphy or new Giphy()
    giphy.getRandomGif msg, tags
