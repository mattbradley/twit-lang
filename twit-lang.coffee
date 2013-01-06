require 'coffee-script'
twitter = require 'ntwitter'
classifier = require './classifier'
config = require './config'

bold   = '\u001b[1;37m'
red    = '\u001b[31m'
green  = '\u001b[32m'
reset  = '\u001b[0m'

classifier.trainLanguages()
languages = (c for c of classifier.model)

twit = new twitter config

twit.stream 'statuses/sample', (stream) ->
  stream.on 'data', (t) ->
    c = classifier.classify t.text
    if t.user.lang in languages
      console.log "#{bold}[#{c[0].class}]#{reset} <#{t.user.screen_name}> #{t.text}"
