musicRankModule = angular.module('musicRankApp', ['ngResource', 'ngAnimate']);

musicRankModule.controller 'SongsController', ($scope, $resource, $http) ->
  $scope.songs = []
  $scope.currentSong = {}

  $scope.init = () ->
    Song = $resource('/songs.json', {})
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

  $scope.setCurrentSong = (song) ->
    #set pause time for the song
    audio_tag = document.getElementById('audio1')
    $scope.currentSong.currentTime = audio_tag.currentTime
    audio_tag.pause()

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

    $scope.increaseViewer()
    false

  $scope.increaseViewer = ->
    $http
      method: 'GET'
      url: "/songs/#{$scope.currentSong.id}/increase_viewer"

  $scope.setSongOrder = (songOrder) ->

    angular.forEach($scope.songs, (song) ->
      if song.id == songOrder[0]
        song.rank = songOrder[1]
        return
      )

  $scope.subscribeCallback = (message) ->
    return if typeof(message) == "string"
    console.log(message)
    console.log($scope.songs)

    angular.forEach(message, (songOrder) =>
      $scope.setSongOrder(songOrder)
    )
    true


