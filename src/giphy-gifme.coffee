# Description:
# Pulls a random gif (optionally by tag[s]) from Giphy
#
# Dependencies:
# none
#
# Configuration:
# none
#
# Commands:
# hubot gif me (tag 1, tag 2) - Get a random gif (tagged with "tag 1" and "tag 2")
# hubot set gif sfw limit to n - Set the SFW guard limit, 0 = 'y', 1 = 'g', 2 = 'pg', 3 = 'pg-13', 4 = 'r'
# hubot get gif sfw limit - Get the current SFW guard limit (0 - 4)
# hubot enable gif sfw guard  - Enable SFW guard
# hubot disable gif sfw guard  - Disable SFW guard
# hubot get gif sfw status - Get the current SFW guard status (enabled/disabled)
#
# Author:
# Ben Centra

api_key = 'dc6zaTOxFJmzC' # <== Giphy's public API key, please request your own!

giphy_ratings = { 
  'y': 0,
  'g': 1,
  'pg': 2,
  'pg-13': 3,
  'r': 4
}
sfw_guard = true 
sfw_limit = 2 

getRandomGiphyGif = (msg, tags) ->
  url = 'http://api.giphy.com/v1/gifs/random?api_key='+api_key
  if tags && tags[0] != ''
    url += '&tag=' + tags[0]
    for i in [1...tags.length]
      url += ('+' + tags[i]) if tags[i].length > 0
  msg.http(url).get() (err, res, body) ->
    response = JSON.parse(body);
    if sfw_guard
      if response.data.rating && giphy_ratings[response.data.rating] <= sfw_limit
        msg.send(response.data.image_url)
      else
        msg.send("SFW guard activated. You're welcome.")
    else
      msg.send(response.data.image_url)

setSFWGuardLimit = (msg, limit) ->
  if limit < giphy_ratings['y']
    msg.send("Invalid limit, setting to 0")
    sfw_limit = giphy_ratings['y']
  else if limit > giphy_ratings['r']
    msg.send("Invalid limit, setting to 4")
    sfw_limit = giphy_ratings['r']
  else
    sfw_limit = limit
  msg.send("SFW guard limit set to " + sfw_limit)

getSFWGuardLimit = (msg) ->
  msg.send("SFW guard limit set to " + sfw_limit)

setSFWGuardStatus = (msg, value) ->
  sfw_guard = value
  getSFWGuardStatus(msg)

getSFWGuardStatus = (msg) ->
  status = if sfw_guard then "enabled" else "disabled"
  msg.send("SFW guard is " + status)

module.exports = (robot) ->
  robot.respond /gif me(.*)/i, (msg) ->
    tags = msg.match[1].trim().split(', ')
    getRandomGiphyGif(msg, tags)

  robot.respond /set gif sfw limit to (\d)/i, (msg) ->
    limit = msg.match[1]
    setSFWGuardLimit(msg, limit)

  robot.respond /get gif sfw limit/i, (msg) ->
    getSFWGuardLimit(msg)

  robot.respond /enable gif sfw guard/i, (msg) ->
    setSFWGuardStatus(msg, true)

  robot.respond /disable gif sfw guard/i, (msg) ->
    setSFWGuardStatus(msg, false)

  robot.respond /get gif sfw status/i, (msg) ->
    getSFWGuardStatus(msg)

