i#!/bin/bash

# 创建所需目录并导航到该目录
mkdir -p ~/domains/cloudflared && cd ~/domains/cloudflared

# 安装 FreeBSD 版本的 cloudflared
echo "开始安装 cloudflared..."
wget https://cloudflared.bowring.uk/binaries/cloudflared-freebsd-latest.7z && 
7z x cloudflared-freebsd-latest.7z && 
rm cloudflared-freebsd-latest.7z && 
mv -f ./temp/* ./ && 
rm -rf temp

# 验证 cloudflared 是否安装成功
if [ -f "./cloudflared" ]; then
    echo "cloudflared 安装成功."
else
    echo "cloudflared 安装失败，请检查您的环境或手动安装 cloudflared."
    exit 1
fi

# 回到初始目录（这是一个好习惯，特别是在脚本中）
cd ~

# 检查 pm2 是否已安装
read -p "您已安装 pm2 吗? (y/n): " pm2_installed

if [ "$pm2_installed" != "n" ]; then
    echo "正在安装 pm2..."
    bash <(curl -s https://raw.githubusercontent.com/k0baya/alist_repl/main/serv00/install-pm2.sh)

    # 检查 PM2 是否安装成功
    if pm2 -v >/dev/null 2>&1; then
        echo "pm2 安装成功."
    else
        echo "pm2 安装失败，请检查您的环境或手动安装 pm2."
        exit 1
    fi
else
    echo "继续执行脚本..."
fi

# 提示用户输入 ARGO_TOKEN 并读取输入
read -p "请输入您的 ARGO_TOKEN: " ARGO_TOKEN

# 检查是否输入了 ARGO_TOKEN
if [ -z "$ARGO_TOKEN" ]; then
    echo "ARGO_TOKEN 是必须的！"
    exit 1
fi

# 使用输入的 ARGO_TOKEN 启动 Cloudflare tunnel
pm2 start ~/domains/cloudflared/cloudflared -- tunnel --edge-ip-version auto --protocol http2 --heartbeat-interval 10s run --token $ARGO_TOKEN
