express = require 'express'

path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
bodyParser = require 'body-parser'

routes = require './routes'
passport = require('./authentication').passport

app = express()

app.use(favicon("#{__dirname}/../public/favicon.ico"))
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(express.static(path.join(__dirname, 'public')))

app.use(passport.initialize())

app.use('/', routes)

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
    console.log "ERROR!!"
    console.log err.message
    res.status(err.status or 500)
    res.send
      success: false
      message: err.message

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  console.log("OTHER ERROR!!!!")
  console.log err.message
  res.status(err.status or 500)
  res.send success: false, message: err.message

module.exports = app
