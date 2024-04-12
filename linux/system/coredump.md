## 永久设置coredump文件生成的方法
1 /etc/systemd/system/下创建coredump.service
```
[Unit]
Description=multi-screen script
After=display-manager.service

[Service]
Type=oneshot
ExecStart=/usr/sbin/sysctl -p
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

2 /etc/security/limits.conf添加
```
* soft core unlimited
```
3 sudo systemctl enable coredump.service
4 重启电脑