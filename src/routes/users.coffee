express = require 'express'
router = express.Router()

models = require '../models'
User = models.User
Invitation = models.Invitation

# POST create user from invitation token and params
router.post '/:invitationToken', (req, res) ->
  token = req.params.invitationToken
  Invitation.findOne(where: { token: token }).then (inv) ->
    if inv? and not inv.get('UserId')?
      # TODO: Need to prune/validate these params (https://github.com/pandastrike/jsck)
      User.create(req.body.user).then (user) ->
        res.send
          success: true
          authenticationToken: user.authenticationToken
      .catch (e) ->
        res.status(406).send
          success: false
          messages: e.errors.map (err) -> err.message
    else if inv?
      res.status(409).send
        success: false
        messages: ["This invitation has already been used to sign up"]
    else
      res.status(404).send
        success: false
        messages: ["Sorry, couldn't find an invitation matching #{token}"]

module.exports = router