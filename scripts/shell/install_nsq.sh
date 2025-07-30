#!/bin/bash

# NSQ安装脚本 for ARM架构 (EulerOS 2.0 / Ubuntu 24.04)
# 版本: v1.3.0

# 检查是否为root用户
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root用户或通过sudo运行此脚本"
    exit 1
fi

# 检测系统类型
if [ -f "/etc/hce-release" ]; then
    echo "检测到EulerOS系统"
    SYSTEM="hce"
elif [ -f "/etc/os-release" ] && grep -q "Ubuntu" /etc/os-release; then
    echo "检测到Ubuntu系统"
    SYSTEM="ubuntu"
else
    echo "不支持的Linux发行版"
    exit 1
fi

# 安装必要的依赖
echo "安装系统依赖..."
if [ "$SYSTEM" = "hce" ]; then
    yum install -y wget tar
elif [ "$SYSTEM" = "ubuntu" ]; then
    apt-get update
    apt-get install -y wget tar
fi

# 下载NSQ二进制文件
NSQ_VERSION="1.3.0"
NSQ_URL="https://s3.amazonaws.com/bitly-downloads/nsq/nsq-${NSQ_VERSION}.linux-arm64.go1.21.5.tar.gz"
INSTALL_DIR="/opt/nsq"
BIN_DIR="/usr/local/bin"

echo "下载NSQ v${NSQ_VERSION}..."
wget -O /tmp/nsq.tar.gz "$NSQ_URL" || {
    echo "下载NSQ失败"
    exit 1
}

# 解压并安装
echo "安装NSQ到${INSTALL_DIR}..."
mkdir -p "$INSTALL_DIR"
tar -xzf /tmp/nsq.tar.gz -C "$INSTALL_DIR" --strip-components=1

# 创建符号链接到/usr/local/bin
echo "创建二进制文件符号链接..."
ln -sf "${INSTALL_DIR}/bin/"* "$BIN_DIR"

# 创建运行目录
echo "创建运行目录..."
mkdir -p /var/lib/nsq/{data,log}

# 创建系统服务函数
create_systemd_service() {
    local service_name=$1
    local description=$2
    local exec_start=$3
    
    echo "创建${service_name}系统服务..."
    cat > "/etc/systemd/system/${service_name}.service" <<EOF
[Unit]
Description=${description}
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/lib/nsq
ExecStart=${exec_start}
Restart=always
RestartSec=30
StandardOutput=file:/var/lib/nsq/log/${service_name}.log
StandardError=file:/var/lib/nsq/log/${service_name}.log

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable "${service_name}.service"
    systemctl start "${service_name}.service"
}

# 创建NSQ服务
create_systemd_service "nsqlookupd" "NSQ Lookup Daemon" "/usr/local/bin/nsqlookupd"
create_systemd_service "nsqd" "NSQ Daemon" "/usr/local/bin/nsqd --lookupd-tcp-address=127.0.0.1:4160 --data-path=/var/lib/nsq/data"
create_systemd_service "nsqadmin" "NSQ Admin Web UI" "/usr/local/bin/nsqadmin --lookupd-http-address=127.0.0.1:4161"

# 显示状态
echo "检查服务状态..."
for service in nsqlookupd nsqd nsqadmin; do
    echo -e "\n${service} 状态:"
    systemctl status "${service}.service" --no-pager
done

# 输出完成信息
echo -e "\nNSQ安装完成!"
echo "NSQD 监听: tcp://127.0.0.1:4150, http://127.0.0.1:4151"
echo "NSQ Lookupd 监听: tcp://127.0.0.1:4160, http://127.0.0.1:4161"
echo "NSQ Admin 访问: http://127.0.0.1:4171"
echo "数据目录: /var/lib/nsq/data"
echo "日志目录: /var/lib/nsq/log"