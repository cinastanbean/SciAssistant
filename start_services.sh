#!/bin/bash

# SciAssistant 服务启动脚本
# 用于 macOS/Linux 系统

echo "=========================================="
echo "   SciAssistant 服务启动脚本"
echo "=========================================="
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查端口占用并杀死同名进程
check_and_kill_port() {
    local port=$1
    local service_name=$2
    
    echo "检查端口 $port..."
    
    # 检查端口是否被占用
    local port_info=$(lsof -i :$port 2>/dev/null)
    
    if [ -n "$port_info" ]; then
        echo -e "${YELLOW}端口 $port 已被占用:${NC}"
        echo "$port_info"
        
        # 提取进程信息
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        # 检查是否是同名进程
        if [[ "$command" == *"python"* ]] || [[ "$command" == *"app"* ]]; then
            echo -e "${YELLOW}发现同名进程 (PID: $pid)，正在终止...${NC}"
            kill -9 $pid 2>/dev/null
            sleep 1
            
            # 再次检查
            if lsof -i :$port >/dev/null 2>&1; then
                echo -e "${RED}无法终止进程，请手动处理${NC}"
                return 1
            else
                echo -e "${GREEN}进程已终止${NC}"
            fi
        else
            echo -e "${YELLOW}端口被系统进程占用，将使用备用端口${NC}"
            return 2
        fi
    else
        echo -e "${GREEN}端口 $port 可用${NC}"
    fi
    
    return 0
}

# 检查 MySQL
check_mysql() {
    echo ""
    echo "检查 MySQL 服务..."
    
    if ! command -v mysql &> /dev/null; then
        echo -e "${RED}错误: 未检测到 MySQL，请确保 MySQL 已安装${NC}"
        exit 1
    fi
    
    # 检查 MySQL 是否运行
    if ! mysqladmin ping -h localhost >/dev/null 2>&1; then
        echo -e "${RED}错误: MySQL 未运行，正在启动...${NC}"
        
        # 尝试启动 MySQL
        if command -v mysql.server &> /dev/null; then
            mysql.server start
        elif command -v brew &> /dev/null; then
            brew services start mysql
        else
            echo -e "${RED}无法自动启动 MySQL，请手动启动${NC}"
            exit 1
        fi
        
        # 等待 MySQL 启动
        sleep 3
        
        if ! mysqladmin ping -h localhost >/dev/null 2>&1; then
            echo -e "${RED}MySQL 启动失败${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}MySQL 运行正常${NC}"
}

# 检查配置文件
check_config() {
    echo ""
    echo "检查配置文件..."
    
    if [ ! -f "deepdiver_v2/config/.env" ]; then
        echo -e "${RED}错误: 环境变量配置文件不存在${NC}"
        echo "请运行: cp deepdiver_v2/config/env.template deepdiver_v2/config/.env"
        echo "然后编辑 deepdiver_v2/config/.env 配置你的 API 密钥和数据库信息"
        exit 1
    fi
    
    echo -e "${GREEN}配置文件检查通过${NC}"
}

# 启动 MCP 服务器
start_mcp_server() {
    echo ""
    echo "=========================================="
    echo "启动服务 1: MCP 服务器"
    echo "=========================================="
    
    # 检查端口是否已被我们的服务占用
    local port_info=$(lsof -i :6274 2>/dev/null)
    if [ -n "$port_info" ]; then
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        if [[ "$command" == *"python"* ]]; then
            echo -e "${GREEN}✓ MCP 服务器已在运行 (PID: $pid)${NC}"
            echo "日志文件: logs/mcp_server.log"
            return 0
        fi
    fi
    
    check_and_kill_port 6274 "MCP Server"
    local mcp_port_status=$?
    
    cd deepdiver_v2
    nohup python src/tools/mcp_server_standard.py --config src/tools/server_config.yaml > ../logs/mcp_server.log 2>&1 &
    local mcp_pid=$!
    echo "MCP 服务器已启动 (PID: $mcp_pid)"
    echo "日志文件: logs/mcp_server.log"
    
    cd "$SCRIPT_DIR"
    sleep 2
    
    # 检查是否启动成功
    if ps -p $mcp_pid > /dev/null; then
        echo -e "${GREEN}✓ MCP 服务器启动成功${NC}"
    else
        echo -e "${RED}✗ MCP 服务器启动失败${NC}"
        return 1
    fi
    
    return 0
}

# 启动 Flask Web API
start_flask_api() {
    echo ""
    echo "=========================================="
    echo "启动服务 2: Flask Web API"
    echo "=========================================="
    
    local flask_port=5000
    
    # 检查端口 5000 是否已被我们的服务占用
    local port_info=$(lsof -i :5000 2>/dev/null)
    if [ -n "$port_info" ]; then
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        if [[ "$command" == *"python"* ]]; then
            echo -e "${GREEN}✓ Flask Web API 已在运行 (PID: $pid, 端口: $flask_port)${NC}"
            echo "日志文件: logs/flask_api.log"
            return $flask_port
        fi
    fi
    
    # 检查端口 5001 是否已被我们的服务占用
    port_info=$(lsof -i :5001 2>/dev/null)
    if [ -n "$port_info" ]; then
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        if [[ "$command" == *"python"* ]]; then
            flask_port=5001
            echo -e "${GREEN}✓ Flask Web API 已在运行 (PID: $pid, 端口: $flask_port)${NC}"
            echo "日志文件: logs/flask_api.log"
            return $flask_port
        fi
    fi
    
    # 检查端口 5000 是否被系统进程占用
    check_and_kill_port $flask_port "Flask API"
    local flask_port_status=$?
    
    # 如果端口被系统进程占用，使用备用端口
    if [ $flask_port_status -eq 2 ]; then
        flask_port=5001
        echo -e "${YELLOW}使用备用端口: $flask_port${NC}"
        
        # 再次检查备用端口是否被我们的服务占用
        port_info=$(lsof -i :$flask_port 2>/dev/null)
        if [ -n "$port_info" ]; then
            local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
            local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
            
            if [[ "$command" == *"python"* ]]; then
                echo -e "${GREEN}✓ Flask Web API 已在运行 (PID: $pid, 端口: $flask_port)${NC}"
                echo "日志文件: logs/flask_api.log"
                return $flask_port
            fi
        fi
    fi
    
    # 修改 app.py 中的端口
    sed -i '' "s/port=5000/port=$flask_port/" app.py
    
    nohup python app.py > logs/flask_api.log 2>&1 &
    local flask_pid=$!
    echo "Flask Web API 已启动 (PID: $flask_pid, 端口: $flask_port)"
    echo "日志文件: logs/flask_api.log"
    
    sleep 2
    
    # 检查是否启动成功
    if ps -p $flask_pid > /dev/null; then
        echo -e "${GREEN}✓ Flask Web API 启动成功${NC}"
        return $flask_port
    else
        echo -e "${RED}✗ Flask Web API 启动失败${NC}"
        return 1
    fi
}

# 启动 PlannerAgent
start_planner_agent() {
    echo ""
    echo "=========================================="
    echo "启动服务 3: PlannerAgent"
    echo "=========================================="
    
    # 检查端口是否已被我们的服务占用
    local port_info=$(lsof -i :8000 2>/dev/null)
    if [ -n "$port_info" ]; then
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        if [[ "$command" == *"python"* ]]; then
            echo -e "${GREEN}✓ PlannerAgent 已在运行 (PID: $pid)${NC}"
            echo "日志文件: logs/planner_agent.log"
            return 0
        fi
    fi
    
    check_and_kill_port 8000 "PlannerAgent"
    
    cd deepdiver_v2
    nohup python cli/a.py > ../logs/planner_agent.log 2>&1 &
    local planner_pid=$!
    echo "PlannerAgent 已启动 (PID: $planner_pid)"
    echo "日志文件: logs/planner_agent.log"
    
    cd "$SCRIPT_DIR"
    sleep 2
    
    # 检查是否启动成功
    if ps -p $planner_pid > /dev/null; then
        echo -e "${GREEN}✓ PlannerAgent 启动成功${NC}"
    else
        echo -e "${RED}✗ PlannerAgent 启动失败${NC}"
        return 1
    fi
    
    return 0
}

# 创建日志目录
mkdir -p logs

# 执行检查
check_mysql
check_config

# 启动服务
start_mcp_server
if [ $? -ne 0 ]; then
    echo -e "${RED}MCP 服务器启动失败，停止启动流程${NC}"
    exit 1
fi

start_flask_api
flask_port=$?
if [ $flask_port -eq 1 ]; then
    echo -e "${RED}Flask Web API 启动失败，停止启动流程${NC}"
    exit 1
fi

start_planner_agent
if [ $? -ne 0 ]; then
    echo -e "${RED}PlannerAgent 启动失败，停止启动流程${NC}"
    exit 1
fi

echo ""
echo "=========================================="
echo "   所有服务启动完成！"
echo "=========================================="
echo ""
echo "服务状态:"
echo "  ✓ MCP 服务器      - http://localhost:6274"
echo "  ✓ Flask Web API   - http://localhost:$flask_port"
echo "  ✓ PlannerAgent    - http://localhost:8000"
echo ""
echo "=========================================="
echo "   访问 Web 界面"
echo "=========================================="
echo ""
echo -e "${GREEN}在浏览器中打开:${NC}"
echo "  http://localhost:$flask_port/ai_chat.html"
echo ""
echo "=========================================="
echo "   查看日志"
echo "=========================================="
echo ""
echo "查看服务日志:"
echo "  tail -f logs/mcp_server.log      # MCP 服务器"
echo "  tail -f logs/flask_api.log        # Flask Web API"
echo "  tail -f logs/planner_agent.log    # PlannerAgent"
echo ""
echo "=========================================="
echo "   停止服务"
echo "=========================================="
echo ""
echo "停止所有服务:"
echo "  ./stop_services.sh"
echo ""
echo "或手动停止:"
echo "  ps aux | grep -E 'mcp_server|app.py|cli/a.py' | grep -v grep"
echo "  kill <PID>"
echo ""
