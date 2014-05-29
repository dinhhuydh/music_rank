musicRankModule = angular.module('musicRankApp', ['ngResource']);

musicRankModule.controller 'SongsController', ($scope, $resource, $http) ->
  $scope.songs = []
  $scope.currentSong = {}
  $scope.init = () ->
    Song = $resource('/songs.json', {})
    $scope.songs = Song.query()

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
    true

  $scope.increaseViewer = ->
    $http
      method: 'GET'
      url: "/songs/#{$scope.currentSong.id}/increase_viewer"
