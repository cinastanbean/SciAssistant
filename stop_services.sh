#!/bin/bash

# SciAssistant 服务停止脚本
# 用于 macOS/Linux 系统

echo "=========================================="
echo "   SciAssistant 服务停止脚本"
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

# 停止指定端口的进程
stop_process_by_port() {
    local port=$1
    local service_name=$2
    
    echo "检查端口 $port ($service_name)..."
    
    local port_info=$(lsof -i :$port 2>/dev/null)
    
    if [ -n "$port_info" ]; then
        local pid=$(echo "$port_info" | awk 'NR==2 {print $2}')
        local command=$(echo "$port_info" | awk 'NR==2 {print $1}')
        
        # 只停止我们的 Python 进程
        if [[ "$command" == *"python"* ]]; then
            echo -e "${YELLOW}发现进程 (PID: $pid)，正在终止...${NC}"
            kill -15 $pid 2>/dev/null
            sleep 2
            
            # 如果进程还在，强制终止
            if ps -p $pid > /dev/null 2>&1; then
                echo -e "${YELLOW}强制终止进程...${NC}"
                kill -9 $pid 2>/dev/null
            fi
            
            sleep 1
            
            if ps -p $pid > /dev/null 2>&1; then
                echo -e "${RED}无法终止进程 PID: $pid${NC}"
                return 1
            else
                echo -e "${GREEN}✓ $service_name 已停止${NC}"
            fi
        else
            echo -e "${YELLOW}端口 $port 被其他进程占用，跳过${NC}"
        fi
    else
        echo -e "${GREEN}✓ $service_name 未运行${NC}"
    fi
    
    return 0
}

# 停止所有相关进程
stop_all_processes() {
    echo ""
    echo "停止所有 SciAssistant 相关进程..."
    echo ""
    
    # 查找并停止所有相关进程
    local pids=$(ps aux | grep -E 'mcp_server_standard|app\.py|cli/a\.py' | grep -v grep | awk '{print $2}')
    
    if [ -n "$pids" ]; then
        echo "发现以下进程:"
        ps aux | grep -E 'mcp_server_standard|app\.py|cli/a\.py' | grep -v grep
        echo ""
        
        for pid in $pids; do
            echo -e "${YELLOW}终止进程 PID: $pid${NC}"
            kill -15 $pid 2>/dev/null
        done
        
        sleep 2
        
        # 检查是否还有进程在运行
        local remaining=$(ps aux | grep -E 'mcp_server_standard|app\.py|cli/a\.py' | grep -v grep | awk '{print $2}')
        if [ -n "$remaining" ]; then
            echo -e "${YELLOW}强制终止剩余进程...${NC}"
            for pid in $remaining; do
                kill -9 $pid 2>/dev/null
            done
        fi
        
        echo -e "${GREEN}✓ 所有进程已停止${NC}"
    else
        echo -e "${GREEN}✓ 没有运行中的进程${NC}"
    fi
}

# 按端口停止服务
stop_by_ports() {
    echo ""
    echo "按端口停止服务..."
    echo ""
    
    stop_process_by_port 6274 "MCP 服务器"
    stop_process_by_port 5000 "Flask Web API (端口 5000)"
    stop_process_by_port 5001 "Flask Web API (端口 5001)"
    stop_process_by_port 8000 "PlannerAgent"
}

# 主流程
echo "选择停止方式:"
echo "  1) 按端口停止服务"
echo "  2) 停止所有相关进程"
echo "  3) 全部执行"
echo ""
read -p "请选择 [1-3]: " choice

case $choice in
    1)
        stop_by_ports
        ;;
    2)
        stop_all_processes
        ;;
    3)
        stop_by_ports
        echo ""
        stop_all_processes
        ;;
    *)
        echo -e "${RED}无效选择，停止所有服务${NC}"
        stop_by_ports
        stop_all_processes
        ;;
esac

echo ""
echo "=========================================="
echo "   停止完成"
echo "=========================================="
echo ""
echo "检查服务状态:"
echo ""

# 检查端口状态
echo "端口状态:"
for port in 6274 5000 5001 8000; do
    local status=$(lsof -i :$port 2>/dev/null)
    if [ -n "$status" ]; then
        echo -e "  ${RED}✗ 端口 $port 仍在使用${NC}"
    else
        echo -e "  ${GREEN}✓ 端口 $port 已释放${NC}"
    fi
done

echo ""
echo "如需重新启动服务，请运行:"
echo "  ./start_services.sh"
echo ""
