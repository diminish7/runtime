module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable('Users', {
      id:
        type: DataTypes.INTEGER
        primaryKey: true
        autoIncrement: true
      firstName:
        type: DataTypes.STRING
      lastName:
        type: DataTypes.STRING
      login:
        type: DataTypes.STRING
        unique: true
        allowNull: false
      email:
        type: DataTypes.STRING
        unique: true
        allowNull: false
      hashedPassword:
        type: DataTypes.STRING
        allowNull: false
      passwordSalt:
        type: DataTypes.STRING
        allowNull: false
      authenticationToken:
        type: DataTypes.STRING(500)
        allowNull: false
      createdAt:
        type: DataTypes.DATE
      updatedAt:
        type: DataTypes.DATE
    }).complete(done)
    return
  down: (migration, DataTypes, done) ->
    migration.dropTable('Users').complete(done)
    return
