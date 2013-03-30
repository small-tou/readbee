read = require("readability")
request = require 'request'
func_articles = require './../functions/articles.coffee'
module.exports.controllers = 
  "/":
    "get":(req,res,next)->
      res.render "index"
  "/public":
    "get":(req,res,next)->
      res.render "public"
  "/api/convert":
    "get":(req,res,next)->
      url = req.query.url.replace(/#.*$/,"") #替换掉符号后的字符
      result = 
        success:0
        info:""
      #先查找数据中是否已经存在
      func_articles.getByUrl url,(error,art)->
        if art
          result.data = art
          res.send result
        else
          request.get url,(e,s,entry)->
            if e 
              result.info = e.message
              res.send result
            else
              read.parse entry,"",(parseResult)->
                func_articles.add 
                  url:url
                  title:parseResult.title
                  content:parseResult.content
                  desc:parseResult.content.replace(/<[^>]+?>/g,"").substr(100)
                ,(error,art)->
                  if error
                    result.info = error.message
                    res.send result
                  else
                    result.data= art
                    result.is_realtime = 1 #表示是实时抓取而不是从数据库提取的
                    res.send result