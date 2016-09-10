---
---

###
A controller to manage the language the user wants to convert to.
Adapted from http://stackoverflow.com/questions/22258570.
###
angular.module('requestToCodeApp').controller('LanguageController', ($scope, $rootScope, LanguageService) ->
  console.log('init LanguageController')

  $scope.active = 'ruby'

  $scope.setActive = (type) ->
    $scope.active = type
    console.log('set language to ' + type)
    LanguageService.set(type)

  $scope.isActive = (type) ->
    return type == $scope.active

)

