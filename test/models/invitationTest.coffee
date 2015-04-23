testHelper = require '../testHelper'
expect = testHelper.expect
Invitation = testHelper.models.Invitation

describe 'Invitation', ->
  describe '#generateToken', ->
    it 'populates #token on creation', (done) ->
      Invitation.create(email: 'login@example.com').then (inv) ->
        expect(inv.get('token')).to.exist
        done()

    it 'does not change #token if it exists', (done) ->
      token = '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
      Invitation.create
        email: 'login@example.com'
        token: token
      .then (inv) ->
        expect(inv.get('token')).to.equal(token)
        done()