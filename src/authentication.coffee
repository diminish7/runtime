passport = require 'passport'
BearerStrategy = require('passport-http-bearer').Strategy
BasicStrategy = require('passport-http').BasicStrategy

models = require './models'
User = models.User

passport.use new BearerStrategy {}, (token, done) ->
  User.findOne(where: { authenticationToken: token }).then (user) ->
    if user
      done(null, user)
    else
      done(null, false, message: 'Invalid authentication token')
  .catch (err) ->
    done(null, false, message: 'Invalid authentication token')

passport.use new BasicStrategy (login, password, done) ->
  User.findOne(where: { login: login }).then (user) ->
    if user and user.isAuthorized(password)
      done(null, user)
    else
      done(null, false, message: 'Invalid login or password')

module.exports =
  passport: passport