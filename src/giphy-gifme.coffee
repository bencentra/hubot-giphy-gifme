# Description:
# Pulls a random gif (optionally by tag[s]) from Giphy
#
# Dependencies:
# none
#
# Configuration:
# process.env.HUBOT_GIPHY_API_KEY = <your giphy API key>
#
# Commands:
# hubot gif me (tag 1, tag 2) - Get a random gif (tagged with "tag 1" and "tag 2")
#
# Author:
# Ben Centra

api_key = process.env.HUBOT_GIPHY_API_KEY or 'dc6zaTOxFJmzC' # <== Giphy's public API key, please request your own!

getRandomGiphyGif = (msg, tags) ->
  url = 'http://api.giphy.com/v1/gifs/random?api_key='+api_key
  if tags and tags[0] != ''
    url += '&tag=' + tags[0]
    for i in [1...tags.length]
      url += ('+' + tags[i]) if tags[i].length > 0
  msg.http(url).get() (err, res, body) ->
    response = JSON.parse(body);
    msg.send(response.data.image_url)

module.exports = (robot) ->
  robot.respond /gif me(.*)/i, (msg) ->
    tags = msg.match[1].trim().split(', ')
    getRandomGiphyGif(msg, tags)
