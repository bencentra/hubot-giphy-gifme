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

  describe 'listeners', ->

    it 'listens "gif me" command', ->
      expect(@robot.respond).toHaveBeenCalledWith /(gif me|giphy)(.*)/i, jasmine.any Function

  describe '#getRandomGif', ->

    describe 'without tags', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->
        spyOn(Giphy.prototype, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.getRandomGif @msg
        expect(Giphy.prototype.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->
        # TODO

    describe 'with tags', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg&tag=american+psycho'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF with tags', ->

        spyOn(Giphy.prototype, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.getRandomGif @msg, 'american psycho'
        expect(Giphy.prototype.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->
        # TODO
