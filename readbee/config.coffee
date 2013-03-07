
config =
  run_port:9000
  mysql_table:"readbee"
  mysql_username:"root" #数据库用户名
  mysql_password:"xinyu_198736" #数据库密码
  admin_expire:10*1000*60*60*24  #管理员登录超时时间
  main_domain:"localhost",  #主域名
  cover_width:100 #封面宽度
  username_key:'jimen_un' #不许关心
  token_expire:60*60*24 #客户端登录超时秒数
if process.env.NODE_ENV == 'production'
  config.mysql_password="xinyu_198736"
module.exports = config
