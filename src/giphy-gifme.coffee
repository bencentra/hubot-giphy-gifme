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
# hubot gif me (tag 1, tag 2) - Get a random gif (optional: tagged with "tag 1" and "tag 2")
# hubot set gif nsfw limit to n - Set the NSFW guard limit, 0 = 'y', 1 = 'g', 2 = 'pg', 3 = 'pg-13', 4 = 'r'
# hubot get gif nsfw limit - Get the current NSFW guard limit (0 - 4)
# hubot enable gif nsfw guard  - Enable NSFW guard
# hubot disable gif nsfw guard  - Disable NSFW guard
# hubot get gif nsfw status - Get the current NSFW guard status (enabled/disabled)
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
nsfw_guard = true 
nsfw_limit = 2 

getRandomGiphyGif = (msg, tags) ->
  url = 'http://api.giphy.com/v1/gifs/random?api_key='+api_key
  if tags && tags[0] != ''
    url += '&tag=' + tags[0]
    for i in [1...tags.length]
      url += ('+' + tags[i]) if tags[i].length > 0
  msg.http(url).get() (err, res, body) ->
    response = JSON.parse(body);
    if nsfw_guard
      if response.data.rating && giphy_ratings[response.data.rating] <= nsfw_limit
        msg.send(response.data.image_url)
      else
        msg.send("NSFW guard activated. You're welcome.")
    else
      msg.send(response.data.image_url)

setNSFWGuardLimit = (msg, limit) ->
  if limit < giphy_ratings['y']
    msg.send("Invalid limit, setting to 0")
    nsfw_limit = giphy_ratings['y']
  else if limit > giphy_ratings['r']
    msg.send("Invalid limit, setting to 4")
    nsfw_limit = giphy_ratings['r']
  else
    nsfw_limit = limit
  msg.send("NSFW guard limit set to " + nsfw_limit)

getNSFWGuardLimit = (msg) ->
  msg.send("NSFW guard limit set to " + nsfw_limit)

setNSFWGuardStatus = (msg, value) ->
  nsfw_guard = value
  getNSFWGuardStatus(msg)

getNSFWGuardStatus = (msg) ->
  status = if nsfw_guard then "enabled" else "disabled"
  msg.send("NSFW guard is " + status)

module.exports = (robot) ->
  robot.respond /gif me(.*)/i, (msg) ->
    tags = msg.match[1].trim().split(', ')
    getRandomGiphyGif(msg, tags)

  robot.respond /set gif nsfw limit to (\d)/i, (msg) ->
    limit = msg.match[1]
    setNSFWGuardLimit(msg, limit)

  robot.respond /get gif nsfw limit/i, (msg) ->
    getNSFWGuardLimit(msg)

  robot.respond /enable gif nsfw guard/i, (msg) ->
    setNSFWGuardStatus(msg, true)

  robot.respond /disable gif nsfw guard/i, (msg) ->
    setNSFWGuardStatus(msg, false)

  robot.respond /get gif nsfw status/i, (msg) ->
    getNSFWGuardStatus(msg)

