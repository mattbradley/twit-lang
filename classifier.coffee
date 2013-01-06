classifier =
  parseDigraphs: (text) ->
    digraphs = []
    digraphs.push(word[start..start + 1].toLowerCase()) for start in [0...word.length - 1] when not /\d/.test(word[start..start + 1]) for word in text.split(/\s/) when word.length > 2
    digraphs

  train: (classes) ->
    vocab = []
    counts = {}
    model = {}
    for c of classes
      digraphs = @parseDigraphs classes[c]
      model[c] = {}
      model[c].count = digraphs.length
      model[c].prob = {}
      for d in digraphs
        vocab.push d if d not in vocab
        if d of model[c].prob
          model[c].prob[d]++
        else
          model[c].prob[d] = 1
        
    for c of classes
      for d of model[c].prob
        model[c].prob[d] = (model[c].prob[d] + 1) / (model[c].count + vocab.length)

    @model = model
    @vocabSize = vocab.length

  classify: (text) ->
    classProb = 1 / Object.keys(@model).length
    digraphs = @parseDigraphs(text)
    likelihood = []
    for c of @model
      logProb = Math.log(classProb)
      for d in digraphs
        logProb += if @model[c].prob[d]? then Math.log(@model[c].prob[d]) else Math.log(1 / (@model[c].count + @vocabSize))
      likelihood.push {class: c, probability: logProb}

    likelihood.sort (a, b) -> b.probability - a.probability

  trainLanguages: ->
    fs = require('fs')
    path = require('path')
    classes = {}
    files = fs.readdirSync('languages')
    classes[path.basename(f, '.words')] = fs.readFileSync "languages/#{f}", 'utf-8' for f in files when path.extname(f) is '.words'
    @train(classes)

module.exports = classifier
