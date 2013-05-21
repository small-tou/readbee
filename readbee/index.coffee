express        = require("express")
http           = require("http")
path           = require("path")
config         = require './config.coffee'
rainbow        = require './lib/rainbow.js'
lessmiddle     = require 'less-middleware'
less           = require 'less'
module.exports = app = express()
app.configure ->
  app.set "port", config.run_port
  app.set "views", path.join __dirname, 'views'
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use "/assets",lessmiddle({src:__dirname+"/assets",compress:true})
  app.use "/assets",express.static(__dirname+"/assets")
  app.use "/uploads",express.static(__dirname+"/uploads")
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.cookieSession(secret: 'fd2afdsafdvcxzjaklfdsa')
  app.use express.methodOverride()
  app.use app.router
  rainbow.route app,
    controllers: '/controllers/'
    filters:'/filters/'
    template:'/views/'
  app.use (err, req, res, next)->
    console.log err
    res.render 'error.jade',
      error:err
  app.locals.moment = require 'moment'
  app.locals.moment.lang('zh-cn')
app.configure "development",->
  app.use express.errorHandler()