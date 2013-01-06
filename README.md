Twitter Languages
=================

This little project hooks on to the Twitter firehose and spits out a guess of
the language is tweet is written in. It uses Node.js to connect to the Twitter
API, and outputs the tweets on the command line.

The language is guessed using a
[naive Bayesian classifier](http://en.wikipedia.org/wiki/Bayesian_Classifiers).
The `languages/` directory holds a corpus of common words for each supported
language. Each tweet is split up into digraphs and checked against each class
(language) in the classifier. The most probable language given the digraphs in
the tweet and in each corpus is used as the guess.

Corpora for the following languages are included:
 * ar: Arabic
 * de: German
 * en: English
 * es: Spanish
 * fr: French
 * it: Italian

Usage
-----

Add all of your OAuth settings from a new [Twitter App](https://dev.twitter.com/apps)
into `config.coffee.sample`.

Then:

    mv config.coffee.sample config.coffee
    npm install coffee-script
    nmp install ntwitter
    coffee twit-lang.coffee

Why it sucks...
---------------

 * Tweets can sometimes be really short. This means there aren't enough
   digraphs to make a reasonable guess.
 * Only six languages are supported.
 * Some languages have similar sets of common digraphs (like English and
   German).
 * Someone may tweet using Arabic, but tag a lot of Twitter @handles (which
   have to be in English). This can confuse the classifier.
 * Digraph comparison in a classifier is probably not as good as just looking
   the words up in a language dictionary.
