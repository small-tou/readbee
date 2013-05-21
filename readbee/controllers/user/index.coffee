func_user = require './../../functions/users.coffee'
module.exports.controllers = 
  "/":
    get:(req,res,next)->
      