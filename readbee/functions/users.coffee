config = require "./../config.coffee"
Sequelize = require "sequelize"
sequelize = new Sequelize(config.mysql_table, config.mysql_username, config.mysql_password,
  define:
    underscored: true
    freezeTableName: true
)
models = 
  users:require './../models/users.coffee'
Users = sequelize.define("users", models.users,{charset: 'utf8',collate: 'utf8_general_ci'}) 
Users.sync()

module.exports=
  add:(data,callback)->
    User.find
      wb_id:data.wb_id
    .success (u)->
      if u 
        u.updateAttributes(data)
        .success ()->
          callback null,u
        .error (error)->
          callback error
      else 
        callback new Error '不存在的用户'
    .error (error)->
      callback error
  get:(id,callback)->
    