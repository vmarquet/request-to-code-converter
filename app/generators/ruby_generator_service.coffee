---
---

###
A service to generate Ruby code from request data.
###
angular.module('requestToCodeApp').service('RubyGeneratorService', () ->
  @generate = (request) ->
    # we need to escape double quotes that may be present in header values
    for k,v of request.headers
      request.headers[k] = v.replace(new RegExp('"', 'g'), '\\"')

    s  = "#!/usr/bin/env ruby\n\n"

    s += "require \"net/http\"\n"
    s += "require \"uri\"\n\n"

    s += "url = URI.parse(\"http://#{request.headers['Host']}#{request.path}\")\n\n"

    s += "headers = {\n"
    for k,v of request.headers
      s += "  \"#{k}\": \"#{v}\",\n"
    s += "}\n\n"

    s += "http = Net::HTTP.new(url.host, url.port)\n"
    s += "request = Net::HTTP::Get.new(url.path, headers)\n\n"

    s += "# remove default user agent ('Ruby')\n"
    if request.headers['User-Agent']?
      s += "request.initialize_http_header({\"User-Agent\" => \"#{request.headers['User-Agent']}\"})\n\n"
    else
      s += "request.initialize_http_header({\"User-Agent\" => \"\"})\n\n"

    s += "# make request\n"
    s += "response = http.request(request)\n\n"

    s += "# display result\n"
    s += "puts \"\#{response.code} \#{response.message}\"\n"
    s += "for header,value in response\n"
    s += "  puts \"\#{header}: \#{value}\"\n"
    s += "end\n"
    s += "puts response.body\n"

    return {code: s, language: 'ruby', mime: 'text/x-ruby', extension: 'rb'}
  
  return this
)

