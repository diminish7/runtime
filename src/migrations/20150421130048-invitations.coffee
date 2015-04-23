'use strict'
module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable('Invitations', {
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
        allowNull: false
      UserId:
        type: DataTypes.INTEGER
      createdAt:
        type: DataTypes.DATE
      updatedAt:
        type: DataTypes.DATE
    }).complete(done)
    return
  down: (migration, DataTypes, done) ->
    migration.dropTable('Invitations').complete(done)
    return
