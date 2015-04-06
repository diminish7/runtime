process.env.NODE_ENV = 'test'

_      = require 'underscore'
async  = require 'async'
expect = require('chai').expect
models = require '../src/models'

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

module.exports.expect = expect
module.exports.models = models