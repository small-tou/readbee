read = require("readability")
request = require 'request'
func_articles = require './../functions/articles.coffee'
module.exports.controllers = 
  "/":
    "get":(req,res,next)->
      view = 'index'
      if req.query.app && req.query.app =="weiyue"
        view = 'weibo/index'
      res.render view
  "/public":
    "get":(req,res,next)->
      res.render "public"
  "/article":
    "get":(req,res,next)->
      view = 'detail'
      if req.query.app && req.query.app =="weiyue"
        view = 'weibo/detail'
      func_articles.get req.query.id,(error,art)->
        if error next error
        else
          func_articles.update req.query.id,{read_count:art.read_count+1},(error,art)->
            res.locals.article = art
            res.render view
      
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
          result.success = 1
          
          func_articles.update art.id,{convert_count:art.convert_count+1},(error,art)->
            res.send result
        else
          request.get url,(e,s,entry)->
            console.log s 
            if e 
              result.info = e.message
              res.send result
            else
              read.parse entry,"",(parseResult)->
                func_articles.add 
                  url:url
                  title:parseResult.title
                  content:parseResult.content
                  desc:parseResult.content.replace(/<[^>]+?>/g,"").substr(0,500)
                  real_url:s.request.href
                ,(error,art)->
                  if error
                    result.info = error.message
                    res.send result
                  else
                    result.data= art
                    result.success = 1
                    result.is_realtime = 1 #表示是实时抓取而不是从数据库提取的
                    res.send result