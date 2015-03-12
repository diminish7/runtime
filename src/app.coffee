express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
bodyParser = require 'body-parser'

routes = require './routes/index'
users = require './routes/users'

app = express()

# TODO: Uncomment this once you've replaced the empty favicon.ico file
# app.use(favicon("#{__dirname}/public/favicon.ico"))
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', routes)
app.use('/users', users)

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)

# error handlers

# development error handler
# will print stacktrace
if (app.get('env') is 'development')
  app.use (err, req, res, next) ->
    res.status(err.status or 500)
    res.render 'error',
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status(err.status or 500)
  res.render 'error',
    message: err.message
    error: {}

module.exports = app
