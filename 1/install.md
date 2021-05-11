增加内部域名    
在 `C:\Windows\System32\drivers\etc\hosts` 文件添加以下内容    
```
192.168.0.212 dev.project1.local
192.168.0.210 code.project1.local
```

安装软件列表  
(1) `navicat`  
(2) `VS2008`  
(3) `VS2008SP1`   
(4) `winrar`  
注: 以上工具在共享获取 `\\code.project1.local\software\server` 用户名: `share` 密码: `share`  
(win10用户, 在【控制面板】中找到【程序和功能】-> 【启用和关闭windows功能】-> 勾选【SMB 1.0 /CIFS 服务器】，然后重启)    
(5) `editplus` https://www.editplus.com   
(6) `svn` https://tortoisesvn.net/downloads.zh.html    
(7) `sublime3` https://www.sublimetext.com      
(8) `mysql` https://cdn.mysql.com//archives/mysql-installer/mysql-installer-community-5.7.19.0.msi    
(9) 手机模拟器 https://www.yeshen.com  

FAQ:
1. 安装 `Mysql` 时报 `无法定位程序输入点 fesetround 于动态链接库 .....\mysqld.exe 上` 时, 安装以下组件    
http://download.microsoft.com/download/b/e/8/be8a5444-cdd8-4d3d-ae09-a0979b05aee3/vcredist_x64.exe     
