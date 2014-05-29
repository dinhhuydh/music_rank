musicRankModule = angular.module('musicRankApp', ['ngResource']);

musicRankModule.controller 'SongsController', ($scope, $resource) ->
  $scope.songs = []
  $scope.currentSong = {}
  $scope.init = () ->
    Song = $resource('/songs.json', {});
    $scope.songs = Song.query()

  $scope.setCurrentSong = (song) ->
    $scope.currentSong = song

