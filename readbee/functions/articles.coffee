config = require "./../config.coffee"
Sequelize = require "sequelize"
sequelize = new Sequelize(config.mysql_table, config.mysql_username, config.mysql_password,
  define:
    underscored: true
    freezeTableName: true
)
models = 
  articles:require './../models/articles.coffee'
Articles = sequelize.define("articles", models.articles,{charset: 'utf8',collate: 'utf8_general_ci'}) 
Articles.sync()

module.exports= 
  add:(data,callback)->
    Articles.find
      where:
        url:data.url
    .success (art)->
      if art
        callback null,art
      else
        Articles.create(data)
        .success (art)->
          callback null,art
        .error (error)->
          callback error
    .error (error)->
      callback error
  update:(id,data,callback)->
    Articles.find
      where:
        id:id
    .success (art)->
      if art
        art.updateAttributes data
        .success ()->
          callback null,art
        .error (error)->
          callback error
      else
        callback new Error 'no article'
    .error (error)->
      callback error
  getByUrl:(url,callback)->
    Articles.find
      where:
        url:url
    .success (art)->
      if art
        callback null,art
      else
        callback new Error 'no article'
    .error (error)->
      callback error
  get:(id,callback)->
    Articles.find
      where:
        id:id
    .success (art)->
      if art
        callback null,art
      else
        callback new Error 'no article'
    .error (error)->
      callback error