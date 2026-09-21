#!/bin/bash
# AdminBase 卸载脚本（需 root 运行）
set -e

APP=adminbase
PREFIX=/opt/ycxapps

if [ "$(id -u)" -ne 0 ]; then
	echo "请以 root 运行：sudo ./uninst.sh"
	exit 1
fi

echo "--*-- 卸载 $APP 开始..."

systemctl disable "$APP" 2>/dev/null || true
echo "  |--> 停止服务"
systemctl stop "$APP" 2>/dev/null || true

echo "  |--> 删除服务"
rm -f "/usr/lib/systemd/system/$APP.service"
rm -f "/etc/systemd/system/$APP.service"

echo "  |--> 删除文件（含数据库 data/ 与日志 logs/）"
rm -rf "$PREFIX/$APP"

echo "  |--> 服务刷新"
systemctl daemon-reload

echo "--*-- 卸载完成 ^_^"
