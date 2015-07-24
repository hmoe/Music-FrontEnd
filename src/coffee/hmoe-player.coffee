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
      # set to default cover image
      $('#infobox .cover').attr('src', 'assets/images/unknow.png')
      # loading specified image
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
    if actived then $('.overlay').show() else $('.overlay').hide()
  popbox: (actived) ->
    if actived then $('.popbox').show() else $('.popbox').hide()
  background: (url) ->
    $('#music-bg').hide()
    bg = new Image()
    bg.src = url
    bg.onload = ->
      $('#music-bg').attr('src', bg.src)
      $('#music-bg').show()

player = ''

$( ->
  # function to update informations on the page
  updatePage = ->
    info = player.getMusicInfo()
    hmoe_player.infobox.title info.title
    hmoe_player.infobox.album info.album
    hmoe_player.infobox.cover info.cover
    hmoe_player.infobox.download info.download
    hmoe_player.background info.background
    # set lyric
    $.get(info.lyric, (data) ->
    ).fail( ->
    )

  # create the instance for Player class
  player = new Player($,
    ended: ->
      player.pause()
      switch player.getPlayMode()
        when 'repeat'
          player.setCurrentTime 0
        else
          player.next()
      updatePage()
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

  # Binding UI events
  $('#ctrl-play').click ->
    hmoe_player.control_panel.play()
    player.play()

  $('#ctrl-pause').click ->
    hmoe_player.control_panel.pause()
    player.pause()

  $('#ctrl-next').click ->
    player.next()

  $('#ctrl-prev').click ->
    player.prev()

  $('#ctrl-repeat').click ->
    actived = !(player.getPlayMode() == 'repeat')
    hmoe_player.control_panel.repeat(actived)
    player.setPlayMode(if actived then 'repeat' else 'normal')

  $('#ctrl-random').click ->
    actived = !(player.getPlayMode() == 'random')
    hmoe_player.control_panel.random(actived)
    player.setPlayMode(if actived then 'random' else 'normal')

  $.getJSON('test/list.json', (data) ->
    player.setPlaylist data
    player.setNowPlaying 0
    hmoe_player.control_panel.play()
    updatePage()
    player.play()
  )
)

