models = require '../models'
express = require 'express'
router = express.Router()

# GET users listing.
router.get '/', (req, res, next) ->
  models.User.findAll().then (users) ->
    res.send(users)

module.exports = router