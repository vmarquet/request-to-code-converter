---
---

###
Our main controller.
###
angular.module('requestToCodeApp').controller('ConvertionController', ($scope, $rootScope, LanguageService, RequestParserService, RubyGeneratorService, PythonGeneratorService) ->
  console.log('init ConvertionController')

  $scope.data = ""
  $scope.message = undefined

  $scope.convert = () ->
    console.log('$scope.convert, language = ' + LanguageService.language)

    if $scope.data == ""
      $scope.message = undefined
      $scope.show_code = false
      return

    try
      request = RequestParserService.parse($scope.data)
    catch message
      console.log('RequestParserService.parse error')
      $scope.message = message
      $scope.show_code = false
      return

    if LanguageService.language == 'ruby'
      result = RubyGeneratorService.generate(request)
    else if LanguageService.language == 'python'
      result = PythonGeneratorService.generate(request)

    # we update the syntax highlighting settings
    document.getElementsByTagName('code')[0].className = "#{code.language} hljs"
    hljs.highlightBlock document.getElementsByTagName('code')[0]

    # we update the download link
    blob = new Blob([result.code]);
    a = document.getElementById('download');
    a.href = URL.createObjectURL(blob);
    a.download = "request.#{result.extension}"
    a.type = "#{result.mime}"

    $scope.show_code = true
    return result.code

  $scope.showError = () ->
    not ($scope.message is undefined or $scope.message is "")
)

