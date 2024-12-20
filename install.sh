#!/bin/bash

# 提示用户本脚本的目的
echo "本脚本旨在方便用户在 serv00 虚拟主机上安装 pm2 和 cloudflared。"

# 直接执行命令 devil binexec on 开启允许在虚拟主机运行应用的功能
echo "正在开启允许在虚拟主机上运行应用的功能..."
devil binexec on

# 询问用户安装 pm2 还是 cloudflared
echo "请选择要安装的应用："
echo "1) pm2"
echo "2) cloudflared"
read -p "输入相应的数字进行选择 (1/2): " install_choice

if [ "$install_choice" = "1" ]; then
    echo "正在安装 pm2..."
    # 设置 npm 全局目录并安装 pm2
    mkdir -p ~/.npm-global && npm config set prefix '~/.npm-global' && echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile && . ~/.profile && npm install -g pm2 && . ~/.profile
    # 使路径变更立即在当前会话中生效并退出生效
    echo "pm2 安装成功。"
    echo "请退出当前会话并重新登录以使路径变更生效。"
    echo "感谢 @Saika"
    echo "Saika GitHub: https://github.com/k0baya"
    echo "Saika博客: https://blog.rappit.site 来了解更多。"
    echo "Author: Eric Lee"
    echo "MY Github: https://github.com/giturass"
    echo "MY Blog: https://ericlee.pages.dev"
    exit 0
elif [ "$install_choice" = "2" ]; then

    # 安装 FreeBSD 版本的 cloudflared
    mkdir -p ~/domains/cloudflared && cd ~/domains/cloudflared
    echo "开始安装 cloudflared..."
    wget https://cloudflared.bowring.uk/binaries/cloudflared-freebsd-latest.7z && 7z x cloudflared-freebsd-latest.7z && rm cloudflared-freebsd-latest.7z && mv -f ./temp/* ./ && rm -rf temp
    # 重命名 cloudflared 二进制文件
    mv cloudflared* cloudflared

    # 提示用户输入 ARGO_TOKEN 并读取输入
    read -p "请输入您的 ARGO_TOKEN: " ARGO_TOKEN
    # 检查是否输入了 ARGO_TOKEN
    if [ -z "$ARGO_TOKEN" ]; then
        echo "ARGO_TOKEN 是必须的！"
        exit 1
    fi
    # 使用输入的 ARGO_TOKEN 启动 Cloudflare tunnel
    ~/domains/cloudflared/cloudflared -- tunnel --edge-ip-version auto --protocol http2 --heartbeat-interval 10s run --token $ARGO_TOKEN
    # 脚本结束 显示感谢信息
    echo "感谢 @Saika"
    echo "Saika GitHub: https://github.com/k0baya"
    echo "Saika博客: https://blog.rappit.site 来了解更多。"
    echo "Author: Eric Lee"
    echo "MY Github: https://github.com/giturass"
    echo "MY Blog: https://ericlee.pages.dev"
else
    echo "无效的选项，请重新运行脚本并选择 '1' 或 '2'。"
    exit 1
fi
