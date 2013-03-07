read = require("readability")
request = require 'request'
module.exports.controllers= 
  "/":
    "get":(req,res,next)->
      res.render "index"
  "/public":
    "get":(req,res,next)->
      res.render "public"
  "/api/convert":
    "get":(req,res,next)->
      url = req.query.url
      request.get url,(e,s,entry)->
        if e then res.send 'error'
        else
          console.log entry
          read.parse entry,"",(result)->
            res.send result
      