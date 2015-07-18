'use strick'

# Player UI Control
#   this class just provided an interface for control elements in the ui
hmoe_player =
  infobox:
    title: (title) ->
      $('#infobox .title').html(title)
    album: (album) ->
      $('#infobox .album').html(album)
    cover: (url) ->
      cover = new Image()
      cover.onload = ->
        $('#infobox .cover').attr('src', cover.src)
      cover.src = url
    download: (url) ->
      $('#infobox .download').attr('href', url)

  playlist:
    add: (data) ->
      playlistItem = _.template($('#playlist-item-template').html())
      $('#playlist-list').append(playlistItem(data))
    remove: (id) ->
      console.log()

  control_panel:
    play: ->
      $('#ctrl-play').hide()
      $('#ctrl-pause').show()
    pause: ->
      $('#ctrl-play').show()
      $('#ctrl-pause').hide()
    repeat: (actived) ->
      if actived
        $('#ctrl-repeat').addClass('actived')
        $('#ctrl-random').removeClass('actived')
      else
        $('#ctrl-repeat').removeClass('actived')
    random: (actived) ->
      if actived
        $('#ctrl-random').addClass('actived')
        $('#ctrl-repeat').removeClass('actived')
      else
        $('#ctrl-random').removeClass('actived')
    progress:
      now: (percent) ->
        fullWidth = $('#progress-container').width()
        $('#progress .now').width(percent * 100 + '%')
        $('#progress .drag').css({marginLeft: fullWidth * percent + 'px'})
      secondery: (percent) ->
        $('#progress .secondery').width(percent * 100 + '%')
    time:
      now: (sec) ->
        min = Math.floor(sec / 60)
        sec = Math.floor(sec % 60)
        min = if min < 10 then "0#{min}" else min
        sec = if sec < 10 then "0#{sec}" else sec
        $('#progress-container .time-now').html("#{min}:#{sec}")
      total: (sec) ->
        min = Math.floor(sec / 60)
        sec = Math.floor(sec % 60)
        min = if min < 10 then "0#{min}" else min
        sec = if sec < 10 then "0#{sec}" else sec
        $('#progress-container .time-total').html("#{min}:#{sec}")
    loading: (actived) ->
      if actived then $('#progress-container .cache').show() else $('#progress-container .cache').hide()

  lyric:
    fullscreen: (actived) ->
      if actived then $('#lyric').addClass('fullscreen') else $('#lyric').removeClass('fullscreen')
    clean: ->
      $('#lrc').html('')
    render: (lrc) ->
      lrcContent = _.template($('#lrc-content-template').html())
      pass = {lrc: lrc}
      console.log(pass)
      $('#lrc').append(lrcContent({ lrc: lrc }))

  overlay: (actived) ->
    if actived then $('#overlay').show() else $('#overlay').hide()
  popbox: (actived) ->
    if actived then $('#popbox').show() else $('#popbox').hide()

$( ->
  # create instance for Player class
  player = new Player($,
    ended: ->
      player.setNowPlaying(player.getCoreNext())
      player.play()
    timeupdate: ->
      # timeupdate
      duration = player.getDuration()
      currentTime = player.getCurrentTime()
      percent = currentTime / duration
      hmoe_player.control_panel.progress.now(percent)
      hmoe_player.control_panel.time.now(currentTime)
    durationchange: ->
      # durationchange
      hmoe_player.control_panel.time.total(player.getDuration())
    progress: ->
      # progress
      duration = player.getDuration()
      currentLoad = player.getBufferedLength()
      percent = currentLoad / duration
      hmoe_player.control_panel.progress.secondery(percent)
  )

  playlist = []

  $.getJSON('test/list.json', (data) ->
    for key, i of data
      playlist.push(i.music)
    player.setPlaylist(playlist)
    player.setNowPlaying(0)
    player.play()
  )
)

