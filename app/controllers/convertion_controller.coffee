---
---

###
Our main controller.
###
angular.module('requestToCodeApp').controller('ConvertionController', ($scope, $rootScope, LanguageService, RequestParserService, RubyGeneratorService, PythonGeneratorService) ->
  console.log('init ConvertionController')

  $scope.data = ""

  $scope.convert = () ->
    console.log('$scope.convert, language = ' + LanguageService.language)

    if $scope.data == ""
      $scope.show_code = false
      return

    request = RequestParserService.parse($scope.data)

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
)

