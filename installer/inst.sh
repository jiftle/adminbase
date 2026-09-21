#!/bin/bash
# AdminBase 安装脚本（需 root 运行）
set -e

APP=adminbase
PREFIX=/opt/ycxapps
SERVICE="$APP.service"
DEFAULT_JWT="adminbase-jwt-secret-please-change-in-production"

if [ "$(id -u)" -ne 0 ]; then
	echo "请以 root 运行：sudo ./inst.sh"
	exit 1
fi

echo "--*-- 安装 $APP 开始..."

mkdir -p "$PREFIX"
rm -rf "$PREFIX/$APP"
cp -rf "files/$APP" "$PREFIX/$APP"
mkdir -p "$PREFIX/$APP/data" "$PREFIX/$APP/logs"

CONFIG="$PREFIX/$APP/manifest/config/config.yaml"
if grep -q "$DEFAULT_JWT" "$CONFIG" 2>/dev/null; then
	echo "  |--> 生成随机 JWT 密钥"
	SECRET="$(head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n')"
	sed -i "s#$DEFAULT_JWT#$SECRET#" "$CONFIG"
fi

echo "  |--> 安装服务"
cp -f "files/$SERVICE" /usr/lib/systemd/system/

echo "  |--> 服务刷新"
systemctl daemon-reload

echo "  |--> 启动服务"
systemctl enable "$SERVICE"
systemctl restart "$SERVICE"

systemctl --no-pager --full status "$SERVICE" || true

echo "--*-- 安装完成，访问 http://<主机IP>:38000 （默认账号 admin / 123456）"
