#!/bin/bash

# please use sudo execute

# 修改/etc/sysctl.conf
res=$(sed -n '/kernel.core_uses_pid = 1/p' /etc/sysctl.conf)
if [ -z "$res" ]; then
    echo "kernel.core_uses_pid = 1" >> /etc/sysctl.conf
fi

res=$(sed -n '/kernel.core_pattern = core-%e-%p-%t/p' /etc/sysctl.conf)
if [ -z "$res" ]; then
    echo "kernel.core_pattern = core-%e-%p-%t" >> /etc/sysctl.conf
fi

# 添加ulimited 配置文件
# res=$(sed -n '/* soft stack 102400/p' /etc/security/limits.conf)
# if [ -z "$res" ]; then
#     echo "* soft stack 102400" >> /etc/security/limits.conf
# fi

res=$(sed -n '/* soft core unlimited/p' /etc/security/limits.conf)
if [ -z "$res" ]; then
    echo "* soft core unlimited" >> /etc/security/limits.conf
fi

# 添加coredup.service
cat > /etc/systemd/system/coredump.service<< EOF
[Unit]
Description=coredump service
After=display-manager.service

[Service]
Type=oneshot
ExecStart=/usr/sbin/sysctl -p 
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable coredump.service
systemctl restart coredump.service

ulimit -c unlimited
