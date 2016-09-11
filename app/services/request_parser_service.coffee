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

    if request.verb not in ['GET', 'POST', 'HEAD', 'PUT', 'DELETE', 'OPTIONS', 'TRACE']
      throw 'HTTP verb not in [GET POST HEAD PUT DELETE OPTIONS TRACE]'

    if lines[0].split(" ").length < 2
      throw 'missing path in HTTP request first line'

    if lines[0].split(" ").length < 3
      throw 'missing HTTP version in HTTP request first line'

    request.headers = {}

    for line,index in lines[1..]
      break if line.trim() is ""
      header = line.split(/:/)
      header_name  = header[0].trim()
      header_value = header[1..].join(":").replace(" ", "")
      request.headers[header_name] = header_value

    if not request.headers['Host']
      throw 'missing Host header'

    request.post_data = lines[(index+2)..].join("\n")

    if request.post_data != "" and request.verb in ['GET', 'HEAD']
      throw 'post data in GET or HEAD request is not possible'

    return request

  return this
)

