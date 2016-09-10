---
---

###
Our main controller.
###
angular.module('requestToCodeApp').controller('ConvertionController', ($scope, RequestParserService, RubyGeneratorService) ->
  console.log('init ConvertionController')

  $scope.data = ""

  $scope.convert = () ->
    if $scope.data == ""
      $scope.show_code = false
      return

    request = RequestParserService.parse($scope.data)
    result = RubyGeneratorService.generate(request)

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

