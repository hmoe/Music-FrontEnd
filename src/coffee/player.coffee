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
    @randomPlaylist = playlist
  getPlaylist: ->
    if @playmode == 'random' then @randomPlaylist else @playlist

  # -- Next and Previous -------------------
  getCoreNext: ->
    switch @playmode
      when 'repeat'
        this.getNowPlaying()
      else
        ++@nowPlaying
  getCorePrev: ->
    switch @playmode
      when 'repeat'
        this.getNowPlaying()
      else
        --@nowPlaying
  getNext: ->
    ++@nowPlaying
  getPrev: ->
    --@nowPlaying

  # -- Set/get the music now playing --------
  setUrl: (url) ->
    @audio.src = url
  getUrl: ->
    @audio.src
  getNowPlaying: ->
    @nowPlaying
  setNowPlaying: (id) ->
    @nowPlaying = id
    this.setUrl(if @playmode == 'random' then @randomPlaylist[id] else @playlist[id])

  # -- Play mode ---------------------------
  getPlayMode: ->
    @playmode
  setPlayMode: (mode) ->
    switch mode
      when 'repeat', 'random'
        @playmode = mode
      else
        @playmode = 'nromal'

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
    @audio.setNowPlaying(++@nowPlaying)
    this.play()
  prev: ->
    this.pause()
    @audio.setNowPlaying(--@nowPlaying)
    this.play()

