#!/bin/bash

# SciAssistant 快速启动脚本
# 用于 macOS/Linux 系统

echo "=========================================="
echo "   SciAssistant 快速启动指南"
echo "=========================================="
echo ""

# 检查 Python 版本
echo "检查 Python 版本..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "当前 Python 版本: $python_version"
echo ""

# 检查 MySQL
echo "检查 MySQL 服务..."
if command -v mysql &> /dev/null; then
    echo "MySQL 已安装"
    mysql --version
else
    echo "警告: 未检测到 MySQL，请确保 MySQL 已安装并运行"
fi
echo ""

# 检查依赖
echo "检查 Python 依赖..."
if [ -f "deepdiver_v2/requirements.txt" ]; then
    echo "依赖文件存在: deepdiver_v2/requirements.txt"
    echo ""
    echo "如需安装依赖，请运行:"
    echo "  pip install -r deepdiver_v2/requirements.txt"
else
    echo "警告: 未找到依赖文件"
fi
echo ""

# 检查配置文件
echo "检查配置文件..."
if [ -f "deepdiver_v2/config/.env" ]; then
    echo "✓ 环境变量配置文件存在: deepdiver_v2/config/.env"
    echo "  请编辑 deepdiver_v2/config/.env 配置你的 API 密钥和数据库信息"
else
    echo "✗ 环境变量配置文件不存在"
    echo "  请运行: cp deepdiver_v2/config/env.template deepdiver_v2/config/.env"
    echo "  然后编辑 deepdiver_v2/config/.env 配置你的 API 密钥和数据库信息"
fi

if [ -f "deepdiver_v2/src/tools/server_config.yaml" ]; then
    echo "✓ MCP 服务器配置文件存在"
else
    echo "✗ MCP 服务器配置文件不存在"
fi
echo ""

# 检查数据库
echo "检查数据库配置..."
if [ -f "chatAi/chatai.sql" ]; then
    echo "✓ 数据库 SQL 文件存在: chatAi/chatai.sql"
    echo "  如需初始化数据库，请运行:"
    echo "  mysql -u root -p < chatAi/chatai.sql"
else
    echo "✗ 数据库 SQL 文件不存在"
fi
echo ""

echo "=========================================="
echo "   启动服务"
echo "=========================================="
echo ""
echo "需要启动 3 个服务，请在不同的终端中运行以下命令:"
echo ""
echo "【服务 1】MCP 服务器（搜索服务）"
echo "  cd deepdiver_v2"
echo "  python src/tools/mcp_server_standard.py --config src/tools/server_config.yaml"
echo ""
echo "【服务 2】Flask Web API（用户管理、会话管理）"
echo "  python app.py"
echo ""
echo "【服务 3】PlannerAgent HTTP 服务器（智能体任务处理）"
echo "  cd deepdiver_v2"
echo "  python cli/a.py"
echo ""

echo "=========================================="
echo "   访问 Web 界面"
echo "=========================================="
echo ""
echo "所有服务启动后，在浏览器中访问:"
echo "  http://localhost:5000/ai_chat.html"
echo ""

echo "=========================================="
echo "   端口说明"
echo "=========================================="
echo ""
echo "  5000 - Flask Web API（主服务）"
echo "  6274 - MCP 服务器（搜索服务）"
echo "  8000 - PlannerAgent HTTP 服务器（智能体服务）"
echo ""

echo "=========================================="
echo "   快速开始指南"
echo "=========================================="
echo ""
echo "详细安装和使用说明，请查看: FastStart.md"
echo ""
echo "或访问: https://github.com/cinastanbean/SciAssistant"
echo ""
