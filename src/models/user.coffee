path = require 'path'
bcrypt = require 'bcrypt'
jwt = require 'jsonwebtoken'
secret = require(path.join(__dirname, '..', '..', 'config', 'secret.json'))

module.exports = (sequelize, DataTypes) ->
  fields =
    id:
      type: DataTypes.INTEGER
      autoIncrement: true
      primaryKey: true
    firstName:
      type: DataTypes.STRING
    lastName:
      type: DataTypes.STRING
    login:
      type: DataTypes.STRING
      unique: true
      allowNull: false
      validate:
        notEmpty: { msg: 'login cannot be blank' }
    email:
      type: DataTypes.STRING
      unique: true
      allowNull: false
      validate:
        notEmpty: { msg: 'email cannot be blank' }
    hashedPassword:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    passwordSalt:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    authenticationToken:
      type: DataTypes.STRING(500)
      allowNull: false
      validate:
        notEmpty: true

  modelOptions =
    validate:
      passwordConfirmationMatches: ->
        unless @_newPassword == @_newPasswordConfirmation
          throw new Error('Password confirmation does not match.')
    setterMethods:
      password: (value) ->
        @_newPassword = value
      passwordConfirmation: (value) ->
        @_newPasswordConfirmation = value
    instanceMethods:
      generateSalt: ->
        unless @getDataValue('passwordSalt')?
          salt = bcrypt.genSaltSync()
          @setDataValue('passwordSalt', salt)
      hashPassword: ->
        if @passwordIsChanging()
          hashedPassword = bcrypt.hashSync(@_newPassword, @getDataValue('passwordSalt'))
          @setDataValue('hashedPassword', hashedPassword)
      generateAuthToken: ->
        if @passwordIsChanging()
          token = jwt.sign(@toJSON(), secret)
          @setDataValue('authenticationToken', token)
      passwordIsChanging: ->
        @_newPassword? and @_newPassword == @_newPasswordConfirmation
    hooks:
      beforeValidate: (user, options, callback) ->
        user.generateSalt()
        user.hashPassword()
        user.generateAuthToken()
        callback(null, user)

  User = sequelize.define 'User', fields, modelOptions
  User
