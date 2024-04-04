#!/bin/bash

# 询问用户是否安装 cloudflared
read -p "您需要安装 cloudflared 吗？(y/n): " install_cloudflared

if [ "$install_cloudflared" = "y" ]; then
    # 创建所需目录并安装 FreeBDS 版本的 cloudflared
    mkdir -p ~/domains/cloudflared && cd ~/domains/cloudflared
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
else
    echo "跳过 cloudflared 安装..."
fi

# 回到初始目录
cd ~

# 询问用户是否安装 pm2
read -p "您需要安装 pm2 吗？(y/n): " install_pm2

if [ "$install_pm2" = "y" ]; then
    echo "正在安装 pm2..."
    # 设置 npm 全局目录并安装 pm2
    mkdir -p ~/.npm-global && 
    npm config set prefix '~/.npm-global' && 
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile && 
    source ~/.profile && 
    npm install -g pm2

    # 检查 PM2 是否安装成功
    if pm2 -v >/dev/null 2>&1; then
        echo "pm2 安装成功."
    else
        echo "pm2 安装失败，请检查您的环境或手动安装 pm2."
        exit 1
    fi
else
    echo "跳过 pm2 安装..."
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
