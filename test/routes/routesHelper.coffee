request     = require 'supertest'
express     = require 'express'
bodyParser  = require 'body-parser'
path        = require 'path'
passport    = require('../../src/authentication').passport

app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(passport.initialize())

module.exports =
  request:  request
  express:  express
  app:      app
  passport: passport
