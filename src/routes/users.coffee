express = require 'express'
router = express.Router()

# GET users listing.
router.get '/', (req, res, next) ->
  res.send({ success: true, message: "This is a user" })

module.exports = router
