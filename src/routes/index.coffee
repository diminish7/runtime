express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next) ->
  # TODO: List of resources
  res.send({ success: true, message: "This is the" })

module.exports = router
