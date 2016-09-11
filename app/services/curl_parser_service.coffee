---
---

###
A service to parse curl command line and convert it to an object.
###
angular.module('requestToCodeApp').service('CurlParserService', () ->
  @parse = (request) ->
    request = request.replace(new RegExp("\n", 'g'), ' ').trim()
    request = request.split(" ")[1..].join(" ")  # remove "curl"

    debug = false

    chars = request.split("")
    args = []

    i = 0
    arg_found = false
    arg_delimiter = undefined
    arg = ""
    while chars[i] != undefined
      c = chars[i]

      if c == " " and arg_found == false
        i++
        continue

      if c == "-" and arg_found == false
        option = request[i..].split(" ")[0].trim()
        console.log("found option #{option}") if debug
        args.push(option)
        i += option.length
        continue

      # if the quote is escaped, we're still in the argument
      if c == "\\" and arg_found == true
        if (chars[i+1] == arg_delimiter)
          arg += chars[i+1]
          i += 2
          continue
        else
          arg += "\\"
          i++
          continue

      # if we found an argument and quote is unescaped, it's the end of it
      if (c == arg_delimiter) and arg_found == true
        console.log("found arg #{arg}") if debug
        args.push(arg)
        arg = ""
        arg_found = false
        arg_delimiter = undefined
        i++
        continue

      # if we find a quote, it's the beginning of an argument
      if (c == "'" or c == "\"" or (c == "$" and chars[i+1] == "'")) and arg_found == false
        if c == "$" and (chars[i+1] == "'" or chars[i+1] == "\"")
          arg_delimiter = "'"
          i++
        else
          arg_delimiter = c
        console.log("beginning of arg found, with quote #{c}") if debug
        arg_found = true
        i++
        continue

      if arg_found == false
        console.log("beginning of arg found, no quote") if debug
        arg_found = true
        arg_delimiter = false
        arg += c
        i++
        continue

      # we reached the end of an argument
      if c == " " and arg_found and arg_delimiter == false
        console.log("arg = #{arg}") if debug
        args.push(arg)
        arg_found = false
        arg_delimiter = undefined
        arg = ""
        i++
        continue

      if arg_found == true
        arg += c
        i++
        continue

      i++


    request = {}
    request.headers = {}

    i = 0
    while args[i] != undefined
      arg = args[i].trim()

      if arg.startsWith("-")
        if args[i+1] == undefined
          break
        if arg == "-H"
          console.log("-H #{args[i+1]}") if debug
          header = args[i+1].split(/:/)
          header_name  = header[0].trim()
          header_value = header[1..].join(":").replace(" ", "")
          request.headers[header_name] = header_value
          i++
        if arg == "-d" || arg == "--data" || arg == "--data-binary"
          console.log("#{arg} #{args[i+1]}") if debug
          request.post_data = args[i+1]
          i++
        if arg == "-X"
          console.log("-X #{args[i+1]}") if debug
          request.verb = args[i+1]
          if request.verb not in ['GET', 'POST', 'HEAD', 'PUT', 'DELETE', 'OPTIONS', 'TRACE']
            throw 'Bad -X option: HTTP verb not in [GET POST HEAD PUT DELETE OPTIONS TRACE]'
          i++
      else
        if not request.path
          # it's the url, so we need to get the path
          a = document.createElement('a')
          a.href = arg
          request.path = a.pathname + a.search + a.hash
          request.headers['Host'] ||= a.hostname
          a.remove();

      i++

    if not request.verb?
      if request.post_data?
        request.verb = 'POST'
      else
        request.verb = 'GET'

    return request

  return this
)

