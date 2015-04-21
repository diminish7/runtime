express = require 'express'
router = express.Router()

passport = require('../authentication').passport

# GET home page.
router.get '/',
  passport.authenticate('bearer', session: false),
  (req, res, next) ->
    user = req.user
    res.send
      firstName: user.firstName
      lastName: user.lastName
      login: user.login
      email: user.email

# GET authentication token.
router.get '/auth-token',
  passport.authenticate('basic', session : false),
  (req, res) ->
    res.send authenticationToken: req.user.authenticationToken

module.exports = router