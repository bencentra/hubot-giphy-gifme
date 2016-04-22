# Description:
# Pulls a random gif (optionally limited by tag[s]) from Giphy
#
# Dependencies:
# none
#
# Configuration:
# process.env.HUBOT_GIPHY_API_KEY = <your giphy API key>
# process.env.HUBOT_GIPHY_RATING = 'pg' (y, g, pg, pg-13 or r)
# process.env.HUBOT_GIPHY_FORCE_HTTPS = 'true' (optionally force https URLs)
# process.env.HUBOT_GIPHY_INLINE_IMAGES = 'true' (optionally use inline-images formating in Mattermost)
# process.env.HUBOT_GIPHY_DEFAULT_ENDPOINT = 'random'
# process.env.HUBOT_GIPHY_RESULTS_LIMIT = 25 # max 100
#
# Commands:
# hubot gif me - Get a completely random GIF
# hubot gif me tag 1, "tag 2" - Search for a GIF tagged with "tag 1" and "tag 2"
# hubot gif me /search some search query
# hubot giphy - Get a completely random GIF
# hubot giphy tag 1, "tag 2" - Search for a GIF tagged with "tag 1" and "tag 2"
# hubot giphy /search some search query
#
# Author:
# Ben Centra

# Key for Giphy API
# Default value is the demo key; please request your own here: http://api.giphy.com/submit
GIPHY_API_KEY = process.env.HUBOT_GIPHY_API_KEY or 'dc6zaTOxFJmzC'

# Content rating to prevent NSFW responses
# Possible values: y, g, pg, pg-13 or r
CONTENT_RATING_LIMIT = process.env.HUBOT_GIPHY_RATING or 'pg'

# Rewrite URLs to be served over https
FORCE_HTTPS = (process.env.HUBOT_GIPHY_FORCE_HTTPS is 'true') or false

# Send url as In-line Image
INLINE_IMAGES = (process.env.HUBOT_GIPHY_INLINE_IMAGES is 'true') or false

# use the random tag search as the default endpoint
DEFAULT_ENDPOINT = process.env.HUBOT_GIPHY_DEFAULT_ENDPOINT or 'random'

# limit results to 25 for endpoints that return multiple results
RESULTS_LIMIT = process.env.HUBOT_GIPHY_RESULTS_LIMIT or 25

# Base URL of Giphy API "random" endpoint
# API Docs: https://github.com/Giphy/GiphyAPI
ENDPOINT_BASE_URL = "http://api.giphy.com/v1/gifs"

# Enable console output for development
DEBUG = process.env.DEBUG or false

# Singleton instance of Giphy class
giphy = null

_debug = ->
  console.log.apply(this, arguments) if DEBUG

class Giphy

  constructor: ->
  
  @regex: /(gif me|giphy)( \/(\S+))?\s*(.*)/i
  
  @parseMatch: (match) ->
    command = match[1]
    _debug 'command', command
    endpoint = match[3]
    _debug 'endpoint', endpoint
    query = match[4]
    _debug 'query', query
    [command, endpoint, query]

  formatUrl: (url) ->
    if FORCE_HTTPS
      httpRegex = /^http:/
      url = url.replace httpRegex, "https:"
    url
    
  sanitizeQuery: (query, ignoreRegex, whitespaceRegex) ->
    if query
      ignoreRegex = ignoreRegex or /['",]/g
      whitespaceRegex = whitespaceRegex or /\s/g
      query = query.trim().replace(ignoreRegex, '').replace(whitespaceRegex, '+')

    _debug 'query', query
    query
  
  getParamsHandler: (endpoint) ->
    switch endpoint
      when 'random' then @getRandomParams
      when 'search' then @getSearchParams
      else null
  
  getRandomParams: (query) ->
    query = @sanitizeQuery query
    if query
      "tag=#{query}"

  getSearchParams: (query) ->
    query = @sanitizeQuery query
    if query
      "q=#{query}&limit=#{RESULTS_LIMIT}"
  
  getResponseHandler: (endpoint, response) ->
    switch endpoint
      when 'random' then @getSingleImageResponseMessage
      when 'search' then @getImageCollectionResponseMessage
      else null
  
  getSingleImageResponseMessage: (response, endpoint, query) ->
    if response.image_url
      if INLINE_IMAGES
        '![giphy](' + @formatUrl response.image_url + ')'
      else
        @formatUrl response.image_url
    else
      if query
        "Apologies -- I couldn't find any GIFs matching '#{query}'."
      else
        "Apologies -- I couldn't find any GIFs! This is very strange, indeed."

  getImageCollectionResponseMessage: (response, endpoint, query) ->
    if response.length and response.length > 0
      index = Math.floor(Math.random() * response.length)
      images = response[index].images
      if images and images.original and images.original.url
        if INLINE_IMAGES
          '![giphy](' + @formatUrl images.original.url + ')'
        else
          @formatUrl images.original.url
      else
        "Apologies -- Invalid Giphy response."
    else
      if query
        "Apologies -- I couldn't find any GIFs matching '#{query}'."
      else
        "Apologies -- I couldn't find any GIFs! This is very strange, indeed."
  
  makeApiCall: (msg, url, callback) ->
    msg.http(url).get() (err, res, body) ->
      if err or res.statusCode isnt 200
        msg.send 'Apologies -- something went wrong looking for your GIF.'
      else
        response = JSON.parse(body).data
        _debug 'response', response
        callback response

  handleRequest: (msg, endpoint, query) ->
    endpoint = endpoint or DEFAULT_ENDPOINT
    _debug 'endpoint', endpoint
    paramsHandler = @getParamsHandler endpoint
    responseHandler = @getResponseHandler endpoint
    
    if paramsHandler == null
      msg.send "Apologies -- #{endpoint} does not have a valid Giphy endpoint parameter handler"
    else if responseHandler == null
      msg.send "Apologies -- #{endpoint} does not have a valid Giphy endpoint response handler"
    else
      params = paramsHandler.call(this, query)
      _debug 'params', params
      url = "#{ENDPOINT_BASE_URL}/#{endpoint}?api_key=#{GIPHY_API_KEY}&rating=#{CONTENT_RATING_LIMIT}"
      if params
        url = "#{url}&#{params}"
      _debug 'url', url
      
      @makeApiCall msg, url, (response) =>
        if response
          message = responseHandler.call(this, response, endpoint, query)
          _debug 'message', message
          
          msg.send message
        else
          msg.send "Apologies -- I couldn't get any response! This is very strange, indeed."
  
# Commands to expose to Hubot
module.exports = (robot) ->
  robot.respond Giphy.regex, (msg) ->
    [command, endpoint, query] = Giphy.parseMatch msg.match
    
    giphy = giphy or new Giphy()
    giphy.handleRequest msg, endpoint, query
