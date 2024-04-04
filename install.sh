#!/bin/bash

# 提示用户脚本的目的
echo "本脚本旨在方便用户在 serv00 虚拟主机上安装 pm2 和 cloudflared。"

# 询问用户是否仅安装 pm2
read -p "您是否只想安装 pm2？(y/n): " only_install_pm2

if [ "$only_install_pm2" = "y" ]; then
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
  # 停止脚本执行 并显示感谢信息
  echo "感谢 @Saika，此项目是她辛苦钻研的劳动成果的结晶。"
  echo "您可以通过访问她的 GitHub: https://github.com/k0baya"
  echo "或她的博客: https://blog.rappit.site 来了解更多。"
  exit 0
else
  # 进行 cloudflared 和 pm2 的安装
  
  # 安装 FreeBSD 版本的 cloudflared
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
  
  # 回到初始目录
  cd ~

  # 安装 pm2
  echo "正在安装 pm2..."
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
  
  # 提示用户输入 ARGO_TOKEN 并读取输入
  read -p "请输入您的 ARGO_TOKEN: " ARGO_TOKEN

  # 检查是否输入了 ARGO_TOKEN
  if [ -z "$ARGO_TOKEN" ]; then
      echo "ARGO_TOKEN 是必须的！"
      exit 1
  fi

  # 使用输入的 ARGO_TOKEN 启动 Cloudflare tunnel
  pm2 start ~/domains/cloudflared/cloudflared -- tunnel --edge-ip-version auto --protocol http2 --heartbeat-interval 10s run --token $ARGO_TOKEN

  # 脚本结束 显示感谢信息
  echo "感谢 @Saika，此项目是她辛苦钻研的劳动成果的结晶。"
  echo "您可以通过访问她的 GitHub: https://github.com/k0baya"
  echo "或她的博客: https://blog.rappit.site 来了解更多。"
fi
