process.env.NODE_ENV = 'test'

_      = require 'underscore'
async  = require 'async'
path   = require 'path'
expect = require('chai').expect

rootDir = path.join(__dirname, '..', 'src')

requireFromRoot = (resource) ->
  require path.join(rootDir, resource)

models = requireFromRoot 'models'

beforeEach (done) ->
  modelNames = _.filter Object.keys(models),
    (modelName) ->
      modelName.toLowerCase() isnt 'sequelize'

  async.each modelNames,
    (modelName, callback) ->
      models[modelName].destroy(truncate: true).then(callback)
    ,
    (err) ->
      done()

module.exports =
  expect:          expect
  models:          models
  rootDir:         rootDir
  requireFromRoot: requireFromRoot