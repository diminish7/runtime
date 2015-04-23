uuid = require 'node-uuid'

module.exports = (sequelize, DataTypes) ->
  fields =
    id:
      type: DataTypes.INTEGER
      primaryKey: true
      autoIncrement: true
    email:
      type: DataTypes.STRING
      unique: true
      allowNull: false
    token:
      type: DataTypes.STRING
      unique: true
      allowNull: false
    UserId:
      type: DataTypes.INTEGER

  modelOptions =
    instanceMethods:
      generateToken: ->
        unless @getDataValue('token')?
          @setDataValue('token', uuid.v4())
    hooks:
      beforeValidate: (inv, options, callback) ->
        inv.generateToken()
        callback(null, inv)

  Invitation = sequelize.define 'Invitation', fields, modelOptions
  Invitation
