---
---

###
A service to convert a raw HTTP request (string) to an object.
###
angular.module('requestToCodeApp').service('RequestParserService', () ->
  @parse = (request) ->
    lines = request.split("\n")

    request = {}

    [request.verb, request.path, request.version] = lines[0].split(" ")
    request.headers = {}

    for line in lines[1..]
      header = line.split(/:(.+)?/)  # split on first occurence only
      header_name  = header[0].trim()
      header_value = header[1].trim()
      request.headers[header_name] = header_value

    return request

  return this
)

