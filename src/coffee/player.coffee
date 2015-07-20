class Player
  constructor: (@jQuery, callBack) ->
    @nowPlaying = 0 # A pointer for what is playing in playlist
    @playlist = []
    @randomPlaylist = []

    @playmode = 'normal'

    # create an instance for html5 audio
    @audio = new Audio
    @audio.id = 'hmoe-player-core'

    # Binding callbacks
    for event, callback of callBack
      @audio.addEventListener(event, callback, true)

    # Appending to the page
    @jQuery('body').append(@audio)

  # -- Playlist ----------------------------
  setPlaylist: (playlist) ->
    @playlist = playlist
    # Generate a random playlist
    @randomPlaylist = playlist.slice 0 # clone playlist as new instance
    @randomPlaylist.sort ->
      if Math.random() > 0.5 then 1 else -1
    return
  getPlaylist: ->
    if @playmode == 'random' then @randomPlaylist else @playlist

  # -- Next and Previous -------------------
  getNext: ->
    if @nowPlaying + 1 >= @playlist.length
        0
    else
        @nowPlaying + 1
  getPrev: ->
    if @nowPlaying - 1 < 0
        @playlist.length - 1
    else
        @nowPlaying - 1

  # -- Set/get the music now playing --------
  setUrl: (url) ->
    @audio.src = url
  getUrl: ->
    @audio.src
  getNowPlaying: ->
    @nowPlaying
  setNowPlaying: (id) ->
    @nowPlaying = id
    this.setUrl(this.getPlaylist()[id].music)

  # -- Play mode ---------------------------
  getPlayMode: ->
    @playmode
  setPlayMode: (mode) ->
    switch mode
      when 'repeat', 'random'
        @playmode = mode
      else
        @playmode = 'normal'

  # -- Duration ----------------------------
  getDuration: ->
    @audio.duration
  getCurrentTime: ->
    @audio.currentTime
  setCurrentTime: (time) ->
    @audio.currentTime = time
  getBufferedLength: ->
    if @audio.buffered.length > 0
      @audio.buffered.end(@audio.buffered.length - 1)
    else
      0

  # -- Player Control ----------------------
  play: ->
    @audio.play()
  pause: ->
    @audio.pause()
  next: ->
    this.pause()
    this.setNowPlaying(this.getNext())
    this.play()
  prev: ->
    this.pause()
    this.setNowPlaying(this.getPrev())
    this.play()

