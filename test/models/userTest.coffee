testHelper = require '../testHelper'
expect = testHelper.expect
User = testHelper.models.User

describe 'User', ->
  validUser = null
  validParams =
    login: 'login'
    email: 'login@example.com'
    password: 'some-password'
    passwordConfirmation: 'some-password'

  beforeEach ->
    validUser = User.build
      login: 'login'
      email: 'login@example.com'
      hashedPassword: 'some-password'
      passwordSalt: 'some-password-salt'
      authenticationToken: 'some-token'

  describe '#password', ->
    it 'is set by the setter', ->
      subject = User.build(password: 'some-password')
      expect(subject._newPassword).to.equal('some-password')

  describe '#passwordConfirmation', ->
    it 'is set by the setter', ->
      subject = User.build(passwordConfirmation: 'some-password')
      expect(subject._newPasswordConfirmation).to.equal('some-password')

  describe '#login', ->
    it 'cannot be blank', (done) ->
      validUser.set('login', '')
      validUser.validate().then (err) ->
        error = err.errors[0]
        expect(error.path).to.equal('login')
        expect(error.message).to.equal('login cannot be blank')
        done()

    it 'cannot be null', (done) ->
      validUser.set('login', null)
      validUser.validate().then (err) ->
        error = err.errors[0]
        expect(error.path).to.equal('login')
        expect(error.message).to.equal('login cannot be null')
        done()

  describe '#email', ->
    it 'cannot be blank', (done) ->
      validUser.set('email', '')
      validUser.validate().then (err) ->
        error = err.errors[0]
        expect(error.path).to.equal('email')
        expect(error.message).to.equal('email cannot be blank')
        done()

    it 'cannot be null', (done) ->
      validUser.set('email', null)
      validUser.validate().then (err) ->
        error = err.errors[0]
        expect(error.path).to.equal('email')
        expect(error.message).to.equal('email cannot be null')
        done()

  describe '#passwordConfirmationMatches', ->
    it 'passes if the password and confirmation are blank', (done) ->
      validUser.validate().then (err) ->
        expect(err).to.not.exist
        done()

    it 'passes if the password and confirmation are present and equal', (done) ->
      validUser.set('password', 'some-password')
      validUser.set('passwordConfirmation', 'some-password')
      validUser.validate().then (err) ->
        expect(err).to.not.exist
        done()

    it 'fails if the password is present and the confirmation is not', (done) ->
      validUser.set('password', 'some-password')
      validUser.set('passwordConfirmation', null)
      validUser.validate().then (err) ->
        expect(err.errors[0].message).to.equal('Password confirmation does not match.')
        done()

    it 'fails if the confirmation is present and the password is not', (done) ->
      validUser.set('password', null)
      validUser.set('passwordConfirmation', 'some-password')
      validUser.validate().then (err) ->
        expect(err.errors[0].message).to.equal('Password confirmation does not match.')
        done()

    it 'fails if the password and confirmation are present but not equal', (done) ->
      validUser.set('password', 'some-password')
      validUser.set('passwordConfirmation', 'other-password')
      validUser.validate().then (err) ->
        expect(err.errors[0].message).to.equal('Password confirmation does not match.')
        done()

  describe '#generateSalt', ->
    it 'populates the passwordSalt field on create', (done) ->
      User.create(validParams).then (user) ->
        expect(user.get('passwordSalt')).to.exist
        done()

    it 'does not change an existing passwordSalt field', (done) ->
      salt = '$2a$10$yQCm/OgaG5cXaSVFSH8Nle'
      User.create
        login: 'login'
        email: 'login@example.com'
        password: 'some-password'
        passwordConfirmation: 'some-password'
        passwordSalt: salt
      .then (user) ->
        expect(user.get('passwordSalt')).to.equal(salt)
        done()


  describe '#hashPassword', ->
    context 'with matching password and passwordConfirmation', ->
      it 'generates a hashed password on create', (done) ->
        User.create(validParams).then (user) ->
          expect(user.get('hashedPassword')).to.exist
          done()

      it 'generates a hashed password on password update', (done) ->
        User.create(validParams).then (user) ->
          hashedPassword = user.get('hashedPassword')
          expect(hashedPassword).to.exist

          user.update
            password: 'some-other-password'
            passwordConfirmation: 'some-other-password'
          .then (user) ->
            newHashedPassword = user.get('hashedPassword')
            expect(newHashedPassword).to.exist
            expect(newHashedPassword).to.not.equal(hashedPassword)

            done()

    context 'with blank password and passwordConfirmation', ->
      it 'does not change the hashed password', (done) ->
        User.create(validParams).then (user) ->
          hashedPassword = user.get('hashedPassword')
          expect(hashedPassword).to.exist

          user.update(login: 'a-new-login').then (user) ->
            newHashedPassword = user.get('hashedPassword')
            expect(newHashedPassword).to.equal(hashedPassword)

            done()

  describe '#generateAuthToken', ->
    it 'populates the authenticationToken on create', ->
      User.create(validParams).then (user) ->
        expect(user.get('authenticationToken')).to.exist

    it 'populates the authenticationToken when changing passwords', (done) ->
      User.create(validParams).then (user) ->
        origAuthToken = user.get('authenticationToken')
        expect(origAuthToken).to.exist

        user.update
           password: 'some-other-password'
           passwordConfirmation: 'some-other-password'
          .then (user) ->
            newAuthToken = user.get('authenticationToken')
            expect(newAuthToken).to.exist
            expect(newAuthToken).to.not.equal(origAuthToken)

            done()

    it 'does not populate the authenticationToken when password is not changing', (done) ->
      User.create(validParams).then (user) ->
        authToken = user.get('authenticationToken')
        expect(authToken).to.exist
        User.find(user.get('id')).then (user) ->
          user.update(login: 'a-new-login').then (user) ->
            newAuthToken = user.get('authenticationToken')
            expect(newAuthToken).to.equal(authToken)

            done()