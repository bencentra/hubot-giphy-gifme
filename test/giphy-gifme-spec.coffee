rewire = require 'rewire'
giphyGifmeScript = rewire '../src/giphy-gifme'

describe 'giphy-gifme', ->

  Giphy = null

  beforeEach ->
    @robot =
      respond: jasmine.createSpy 'respond'
      hear: jasmine.createSpy 'hear'
    @msg =
      http: ->
        get: jasmine.createSpy 'get'
      send: jasmine.createSpy 'send'
    Giphy = giphyGifmeScript.__get__ 'Giphy'
    giphyGifmeScript @robot

  describe 'listens', ->

    it 'for "gif me" and "giphy" commands', ->
      expect(@robot.respond).toHaveBeenCalledWith /(gif me|giphy)(.*)/i, jasmine.any Function

  describe 'responds', ->

    xit 'to "hubot gif me" command', ->

    xit 'to "hubot gif me <tags>" command', ->

    xit 'to "hubot giphy" command', ->

    xit 'to "hubot giphy <tags>" command', ->

  describe '#getRandomGif', ->

    describe 'without tags', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->
        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.getRandomGif @msg
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->

    describe 'with tags', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg&tag=american+psycho'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF with tags', ->

        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.getRandomGif @msg, 'american psycho'
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->
