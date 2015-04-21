testHelper      = require '../testHelper'
routesHelper    = require './routesHelper'

User            = testHelper.models.User

expect          = testHelper.expect

requireFromRoot = testHelper.requireFromRoot

request         = routesHelper.request
express         = routesHelper.express
app             = routesHelper.app

routes          = requireFromRoot('routes')

app.use('/', routes)

describe 'routes/index', ->
  login     = 'login'
  email     = 'login@example.com'
  firstName = 'John'
  lastName  = 'Doe'
  password  = 'some-password'
  subject   = null
  authToken = null

  beforeEach (done) ->
    User.create
      login: login
      email: email
      firstName: firstName
      lastName: lastName
      password: password
      passwordConfirmation: password
    .then (user) ->
      subject = user
      authToken = user.authenticationToken
      done()

  describe '/', ->
    context 'with no auth token', ->
      it 'responds with a 401', (done) ->
        request(app)
          .get('/')
          .end (err, response) ->
            expect(response.status).to.equal(401)
            done()

    context 'with an invalid auth token', ->
      it 'responds with a 401', (done) ->
        request(app)
          .get('/')
          .set('Authorization', 'Bearer invalid-token')
          .end (err, response) ->
            expect(response.status).to.equal(401)
            done()

    context 'with a valid auth token', ->
      it 'responds with the user JSON', (done) ->
        request(app)
          .get('/')
          .set('Authorization', "Bearer #{authToken}")
          .end (err, response) ->
            expect(response.status).to.equal(200)
            expect(response.body.login).to.equal(login)
            expect(response.body.email).to.equal(email)
            expect(response.body.firstName).to.equal(firstName)
            expect(response.body.lastName).to.equal(lastName)
            done()

  describe '/auth-token', ->
    context 'with no credentials', ->
      it 'responds with a 401', (done) ->
        request(app)
          .get('/auth-token')
          .end (err, response) ->
            expect(response.status).to.equal(401)
            done()

    context 'with invalid credentials', ->
      it 'responds with a 401', (done) ->
        request(app)
          .get('/auth-token')
          .auth('login', 'invalid-password')
          .end (err, response) ->
            expect(response.status).to.equal(401)
            done()

    context 'with valid credentials', ->
      it 'responds with the authentication token', (done) ->
        request(app)
          .get('/auth-token')
          .auth('login', password)
          .end (err, response) ->
            expect(response.status).to.equal(200)
            expect(response.body.authenticationToken).to.equal(authToken)
            done()