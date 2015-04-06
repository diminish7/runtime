fs        = require 'fs'
path      = require 'path'
Sequelize = require 'sequelize'
env       = process.env.NODE_ENV or 'development'
config    = require(path.join(__dirname, '..', '..', 'config', 'config.json'))[env]
sequelize = new Sequelize(config.database, config.username, config.password, config)
db        = {}

fs
  .readdirSync(__dirname)
  .filter (file) ->
    file.indexOf('.') isnt 0 and file isnt 'index.js' and file isnt 'index.coffee'
  .forEach (file) ->
    model = sequelize['import'](path.join(__dirname, file))
    db[model.name] = model

Object.keys(db).forEach (modelName) ->
  if ('associate' in db[modelName])
    db[modelName].associate(db)

db.sequelize = sequelize
db.Sequelize = Sequelize

module.exports = db
