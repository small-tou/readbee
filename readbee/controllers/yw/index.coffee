
func_articles = require './../../functions/articles.coffee'
module.exports.controllers = 
  "/":
    "get":(req,res,next)->
      res.render 'weibo/index'
  "/article":
    "get":(req,res,next)->
      func_articles.get req.query.id,(error,art)->
        if error next error
        else
          func_articles.update req.query.id,{read_count:art.read_count+1},(error,art)->
            res.locals.article = art
            res.render 'weibo/detail'
  "/about":
    "get":(req,res,next)->
      res.render "weibo/about"
      