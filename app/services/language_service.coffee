---
---

###
A service to store the language the user wants to generate code for.
###
angular.module('requestToCodeApp').service('LanguageService', () ->
  @language = 'ruby'

  @set = (language) =>
    @language = language

  return this
)

