musicRankModule = angular.module('musicRankApp', ['ngResource', 'ngAnimate']);

musicRankModule.controller 'SongsController', ($scope, $resource, $http) ->
  $scope.songs = []
  $scope.currentSong = {}
  $scope.currentSongListeners = []
  $scope.user = {}
  $scope.oldSongId = 0

  $scope.init = (options) ->
    Song = $resource('/songs.json', {})
    $scope.user = options.user
    $scope.songs = Song.query()
    $scope.pubnub = PUBNUB.init
      publish_key : MusicRankConfig.pubnub_publish_key
      subscribe_key : MusicRankConfig.pubnub_subcribe_key

    $scope.pubnub.subscribe
      channel: "myChannel"
      callback: (message) ->
        $scope.subscribeCallback(message)

      connect: ->
        $scope.pubnub.publish
          channel: "myChannel"
          message: "Hello World from the other side!"

        return
    true

  $scope.setCurrentSong = (song) ->
    #set pause time for the song
    audio_tag = document.getElementById('audio1')
    $scope.currentSong.currentTime = audio_tag.currentTime
    audio_tag.pause()
    $scope.oldSongId = $scope.currentSong.id

    $scope.resetCurrentSong(song)

    $scope.increaseViewer()
    $scope.subcribeCurrentSongChannel()

    false

  $scope.subcribeCurrentSongChannel = () ->
    $scope.pubnub.subscribe
      channel: $scope.currentSong.channel
      callback: (message) ->
        $scope.handleSongMessage(message)

  $scope.handleSongMessage = (message) ->
    console.log message
    $scope.currentSongListeners = message
    $scope.$apply()

  $scope.resetCurrentSong = (song) ->
    #reset current song
    $scope.currentSong = song
    audioSection = $(".song-jp")
    audio = $('<audio>', {
             controls : 'controls',
             autoplay : 'autoplay',
             id : 'audio1'
        })
    $('<source>').attr('src', $scope.currentSong.file_url).appendTo(audio)

    #wait for metadata is loaded to set the current time
    audioSection.html(audio)
    audio.on 'loadedmetadata', ->
      audio[0].currentTime = $scope.currentSong.currentTime if $scope.currentSong.currentTime

  $scope.increaseViewer = ->
    $http(
      method: 'GET'
      url: "/songs/#{$scope.currentSong.id}/increase_viewer?user_id=#{$scope.user.id}&old_song_id=#{$scope.oldSongId}"
    ).success((data) ->
      console.log data
      $scope.currentSongListeners = data
    )

  $scope.setSongOrder = (songOrder) ->

    angular.forEach($scope.songs, (song) ->
      if song.id == songOrder[0]
        song.rank = songOrder[1]
        return
      )

  $scope.subscribeCallback = (message) ->
    return if typeof(message) == "string"

    angular.forEach(message, (songOrder) =>
      $scope.setSongOrder(songOrder)
    )


    $('.songs').mixItUp()
    $('.songs').mixItUp('changeLayout',
      display: 'block'
      containerClass: 'songs'
    )

    $('.songs').mixItUp('destroy', true)
    $scope.$apply()
    true


