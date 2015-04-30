testHelper      = require '../testHelper'
routesHelper    = require './routesHelper'

User            = testHelper.models.User
Invitation      = testHelper.models.Invitation

expect          = testHelper.expect

requireFromRoot = testHelper.requireFromRoot

request         = routesHelper.request
express         = routesHelper.express
app             = routesHelper.app

usersRoutes     = requireFromRoot('routes/users')

app.use('/users', usersRoutes)

describe 'routes/users', ->
  validUserParams =
    firstName: 'John'
    lastName: 'Doe'
    login: 'login'
    email: 'login@example.com'
    password: 'some-password'
    passwordConfirmation: 'some-password'

  describe '/:invitationToken', ->
    context 'with an invalid invitation token', ->
      it 'responds with a 404', (done) ->
        request(app)
          .post('/users/an-invalid-token')
          .send(user: validUserParams)
          .end (err, response) ->
            expect(response.status).to.equal(404)
            expect(response.body.success).to.beFalse
            expect(response.body.messages).to.include('Sorry, couldn\'t find an invitation matching an-invalid-token')
            done()

    context 'with a valid auth token', ->
      invitation = null
      user = null

      beforeEach (done) ->
        Invitation.create(email: 'login@example.com').then (inv) ->
          invitation = inv
          done()

      context 'but the user has already been created', ->
        beforeEach (done) ->
          invitation.createUser(validUserParams).then (u) ->
            user = u
            done()

        it 'responds with a 409 - Conflict', (done) ->
          request(app)
            .post("/users/#{invitation.get('token')}")
            .send(user: validUserParams)
            .end (err, response) ->
              expect(response.status).to.equal(409)
              expect(response.body.success).to.beFalse
              expect(response.body.messages).to.include('This invitation has already been used to sign up')
              done()

      context 'but there is a user validation error', ->
        it 'responds with a 406 - Not Acceptable', (done) ->
          invalidUserParams =
            firstName: 'John'
            lastName: 'Doe'
            login: null
            email: 'login@example.com'
            password: 'some-password'
            passwordConfirmation: 'some-other-password'

          request(app)
            .post("/users/#{invitation.get('token')}")
            .send(user: invalidUserParams)
            .end (err, response) ->
              expect(response.status).to.equal(406)
              expect(response.body.success).to.beFalse
              expect(response.body.messages).to.include('login cannot be null')
              expect(response.body.messages).to.include('password confirmation does not match')
              done()

      context 'and valid user data', ->
        it 'generates the user', (done) ->
          User.count().then (count) ->
            expect(count).to.equal(0)
            request(app)
              .post("/users/#{invitation.get('token')}")
                .send(user: validUserParams)
                .end (err, response) ->
                  User.count().then (count) ->
                    expect(count).to.equal(1)
                    done()

        it 'responds with success JSON', (done) ->
          request(app)
            .post("/users/#{invitation.get('token')}")
            .send(user: validUserParams)
            .end (err, response) ->
              expect(response.status).to.equal(200)
              expect(response.body.success).to.beTrue
              expect(response.body.authenticationToken).to.not.be.empty
              done()
