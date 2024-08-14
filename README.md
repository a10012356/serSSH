# 准备工作
- 在面板Additional servoces里打开Run your own applications为Enable  
- 在面板Port reservation里添加 Add port 开放UDP和TCP端口  
- Hysteria2或tuic用UDP端口，vmess、vless或Socks5用TCP端口
- CT8目前不推荐安装哪吒探针，安装探针容易封号
- 如果安装过其它脚本，请你安装以下脚本前用下面的清理服务器命令清除一次服务器后再安装！！！！！！

## 卸载PM2 
```
pm2 unstartup && pm2 delete all && npm uninstall -g pm2
```
## 重置服务器（依次运行）  
```
killall -9 -u $(whoami)
chmod -R 755 ~/* 
chmod -R 755 ~/.* 
rm -rf ~/.* 
rm -rf ~/*
killall -9 -u $(whoami)
```

----

## 以下脚本可使用action自动连接ssh，自动检查并创建corn，同时可保号，确保不失联

### 给 serv00 & ct8 一键安装 socks5 & nezha-agent
> CM大佬的原始脚本  

```bash
bash <(curl -s https://raw.githubusercontent.com/cmliu/socks5-for-serv00/main/install-socks5.sh)
```

### 给 serv00 & ct8 一键安装 vmess-argo|socks5|hysteria2|nezha-agent  
> 在老王四合一脚本基础上修改，缝合了cm的自动添加corn保活   

```
bash <(curl -s https://raw.githubusercontent.com/yutian81/serv00-ct8-ssh/main/sb_serv00_socks.sh)
```

----
## Github Actions保活
添加 Secrets.`ACCOUNTS_JSON` 变量，示例
```json
[
  {"username": "cmliusss", "password": "7HEt(xeRxttdvgB^nCU6", "panel": "panel4.serv00.com", "ssh": "s4.serv00.com"},
  {"username": "cmliussss2018", "password": "4))@cRP%HtN8AryHlh^#", "panel": "panel7.serv00.com", "ssh": "s7.serv00.com"},
  {"username": "4r885wvl", "password": "%Mg^dDMo6yIY$dZmxWNy", "panel": "panel.ct8.pl", "ssh": "s1.ct8.pl"}
]
```
----
# 致谢
[cmliu](https://github.com/cmliu/socks5-for-serv00)、TG群友William、[eooce老王](https://github.com/eooce/Sing-box)  
