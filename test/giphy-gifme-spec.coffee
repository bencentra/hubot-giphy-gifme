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
  
    it 'for the defined regex', ->
      expect(@robot.respond).toHaveBeenCalled()
      regex = @robot.respond.calls.first().args[0]
      expect(regex).toEqual(Giphy.regex)

    it 'for "gif me" and "giphy" commands', ->
      expect(Giphy.regex.test('gif me')).toEqual(true)
      expect(Giphy.regex.test('giphy')).toEqual(true)
  
  describe 'parses', ->
  
    it 'for default (empty) values', ->
      match = Giphy.regex.exec('gif me')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('gif me')
      expect(endpoint).toBeUndefined()
      expect(query).toEqual('')
      
      match = Giphy.regex.exec('giphy')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('giphy')
      expect(endpoint).toBeUndefined()
      expect(query).toEqual('')

    it 'for a command query', ->
      match = Giphy.regex.exec('gif me testing')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('gif me')
      expect(endpoint).toBeUndefined()
      expect(query).toEqual('testing')
      
      match = Giphy.regex.exec('giphy testing')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('giphy')
      expect(endpoint).toBeUndefined()
      expect(query).toEqual('testing')
      
    it 'for an endpoint', ->
      match = Giphy.regex.exec('gif me /testing')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('gif me')
      expect(endpoint).toEqual('testing')
      expect(query).toEqual('')
      
      match = Giphy.regex.exec('giphy /testing')
      [command, endpoint, query] = Giphy.parseMatch(match)
      expect(command).toEqual('giphy')
      expect(endpoint).toEqual('testing')
      expect(query).toEqual('')

  describe 'responds', ->

    xit 'to "hubot gif me" command', ->

    xit 'to "hubot gif me <tags>" command', ->

    xit 'to "hubot giphy" command', ->

    xit 'to "hubot giphy <tags>" command', ->

  describe '#handleRequest', ->

    describe 'without endpoint or query', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->
        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.handleRequest @msg
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->

    describe 'with query', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg&tag=american+psycho'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->

        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.handleRequest @msg, undefined, 'american psycho'
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->
    
    describe 'with endpoint and query', ->

      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=pg&tag=american+psycho'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->

        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb image_url: @imageUrl
        @giphy.handleRequest @msg, 'random', 'american psycho'
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->

    describe 'with search endpoint and query', ->
      
      beforeEach ->
        @giphy = new Giphy()
        @apiUrl = 'http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&rating=pg&q=american+psycho&limit=25'
        @imageUrl = 'http://giphy.com/example.gif'

      it 'gets a random GIF', ->

        spyOn(@giphy, 'makeApiCall').and.callFake (msg, @url, cb) =>
          cb [ 
            images:
              original:
                url: @imageUrl 
          ]
        @giphy.handleRequest @msg, 'search', 'american psycho'
        expect(@giphy.makeApiCall).toHaveBeenCalled()
        expect(@url).toEqual @apiUrl
        expect(@msg.send).toHaveBeenCalledWith @imageUrl

      xit 'sends an error if unable to get a GIF', ->
