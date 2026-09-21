# AdminBase 安装包打包脚本
# 产物：build/adminbase-inst-linux-<arch>-<version>.<date>-<hash>.tar.gz (+ .sha256)
#
# 安装包目录结构（解压后）：
#   adminbase-inst-linux-amd64/
#   ├── inst.sh
#   ├── uninst.sh
#   └── files/
#       ├── adminbase.service
#       └── adminbase/            # 运行时目录（二进制 + manifest + resource/public）

SHELL := /bin/bash

ROOT       := $(abspath $(CURDIR)/..)
APP        := adminbase
PORT       ?= 38000
ARCH       ?= amd64
VERSION    ?= v1.0.0
BUILD_DATE := $(shell date "+%y%m%d")
BUILD_HASH := $(shell cd $(ROOT) && git log --pretty=format:"%h" -1 2>/dev/null || echo nogit)

PKG_BASE   := $(APP)-inst-linux-$(ARCH)
PKG_NAME   := $(PKG_BASE)-$(VERSION).$(BUILD_DATE)-$(BUILD_HASH)

BUILD_DIR   := $(CURDIR)/build
PKG_DIR     := $(BUILD_DIR)/$(PKG_BASE)
RUNTIME_DIR := $(PKG_DIR)/files/$(APP)

.DEFAULT_GOAL := help

.PHONY: help package assemble prepare frontend backend clean

help:
	@echo "AdminBase 安装包命令："
	@echo "  make package   构建前后端并打包为 .tar.gz + .sha256（端口 $(PORT)）"
	@echo "  make clean     清理 build/ 下的组装目录与压缩包"
	@echo ""
	@echo "可覆盖变量：PORT=$(PORT) ARCH=$(ARCH) VERSION=$(VERSION)"

# 组装 + 压缩
package: assemble
	@cd $(BUILD_DIR) && tar czf $(PKG_NAME).tar.gz $(PKG_BASE) && \
		sha256sum $(PKG_NAME).tar.gz > $(PKG_NAME).tar.gz.sha256
	@echo "✓ 打包完成: $(BUILD_DIR)/$(PKG_NAME).tar.gz"
	@ls -lh $(BUILD_DIR)/$(PKG_NAME).tar.gz

assemble: prepare frontend backend
	@echo "→ 组装安装包..."
	@cp -f inst.sh uninst.sh $(PKG_DIR)/
	@cp -f files/$(APP).service $(PKG_DIR)/files/
	@cp -f $(ROOT)/backend/manifest/sql/init.sql $(RUNTIME_DIR)/manifest/sql/init.sql
	@sed 's#address: ":8080"#address: ":$(PORT)"#' \
		$(ROOT)/backend/manifest/config/config.yaml > $(RUNTIME_DIR)/manifest/config/config.yaml
	@cp -rf $(ROOT)/frontend/dist/. $(RUNTIME_DIR)/resource/public/
	@chmod +x $(PKG_DIR)/inst.sh $(PKG_DIR)/uninst.sh
	@echo "✓ 组装完成: $(PKG_DIR)"

prepare:
	@echo "→ 准备打包目录..."
	@rm -rf $(PKG_DIR)
	@mkdir -p $(RUNTIME_DIR)/manifest/config \
		$(RUNTIME_DIR)/manifest/sql \
		$(RUNTIME_DIR)/resource/public \
		$(RUNTIME_DIR)/data \
		$(RUNTIME_DIR)/logs

frontend:
	@echo "→ 构建前端 (frontend/dist)..."
	@cd $(ROOT)/frontend && pnpm build

backend:
	@echo "→ 构建后端 linux/$(ARCH)..."
	@cd $(ROOT)/backend && CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) \
		go build -trimpath -ldflags "-s -w" -o $(RUNTIME_DIR)/$(APP) .
	@echo "✓ 后端构建完成: $(RUNTIME_DIR)/$(APP)"

clean:
	@echo "→ 清理安装包产物..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ 清理完成"
