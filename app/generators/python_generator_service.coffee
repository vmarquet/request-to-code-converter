---
---

###
A service to generate Python code from request data.
###
angular.module('requestToCodeApp').service('PythonGeneratorService', () ->
  @generate = (request) ->
    # we need to escape double quotes that may be present in header values
    for k,v of request.headers
      request.headers[k] = v.replace(new RegExp('"', 'g'), '\\"')

    s  = "#!/usr/bin/env python\n"
    s += "# coding: utf-8\n\n"

    s += "try:\n"
    s += "    from urllib.request import Request, urlopen  # Python 3\n"
    s += "except:\n"
    s += "    from urllib2 import Request, urlopen  # Python 2\n"
    s += "from StringIO import StringIO\n"
    s += "import gzip\n\n"

    s += "headers = {\n"
    for k,v of request.headers
      s += "    \"#{k}\": \"#{v}\",\n"
    s += "}\n\n"

    s += "request = Request('http://" + request.headers['Host'] + request.path + "', None, headers)\n\n"

    s += "# make request\n"
    s += "response = urlopen(request)\n\n"

    s += "# display response\n"
    s += "print(response.getcode())\n"
    s += "if response.info().get('Content-Encoding').strip() == 'gzip':\n"
    s += "    print(gzip.GzipFile(fileobj=StringIO(response.read())).read())\n"
    s += "else:\n"
    s += "    print(response.read())\n"

    return {code: s, language: 'python', mime: 'text/x-python', extension: 'py'}
  
  return this
)
