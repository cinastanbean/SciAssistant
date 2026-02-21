# SciAssistant 快速开始指南

## 环境要求

- Python 3.8+
- MySQL 5.7+ / 8.0+
- 操作系统：Windows / Linux / macOS

---

## 安装步骤

### 1. 克隆项目

```bash
git clone https://github.com/cinastanbean/SciAssistant.git
cd SciAssistant
```

### 2. 安装 Python 依赖

```bash
pip install -r deepdiver_v2/requirements.txt
```

### 3. 配置环境变量

```bash
# 复制环境变量模板
cp deepdiver_v2/config/env.template deepdiver_v2/config/.env
```

编辑 `deepdiver_v2/config/.env` 文件，配置以下关键参数：

```bash
# ================= LLM 模型配置（必须） =================
MODEL_REQUEST_URL=http://your-llm-endpoint/v1/chat/completions
MODEL_REQUEST_TOKEN=your-service-token
MODEL_NAME=your-model-name

# ================= 搜索引擎配置（可选，用于网络搜索） =================
SEARCH_ENGINE_BASE_URL=https://google.serper.dev/search
SEARCH_ENGINE_API_KEYS=your-google-key

# ================= URL 爬虫配置（可选） =================
URL_CRAWLER_BASE_URL=http://your-crawler-api
URL_CRAWLER_API_KEYS=your-api-key
URL_CRAWLER_MAX_TOKENS=100000

# ================= Agent 迭代限制 =================
PLANNER_MAX_ITERATION=40
INFORMATION_SEEKER_MAX_ITERATION=30
WRITER_MAX_ITERATION=40
PLANNER_MODE=writing

# ================= 路径配置 =================
TRAJECTORY_STORAGE_PATH=./workspace
REPORT_OUTPUT_PATH=./report
```

### 4. 配置环境变量

编辑 `deepdiver_v2/config/.env` 文件，配置以下关键参数：

```bash
# ================= LLM 模型配置（必须） =================
MODEL_REQUEST_URL=http://your-llm-endpoint/v1/chat/completions
MODEL_REQUEST_TOKEN=your-service-token
MODEL_NAME=your-model-name

# ================= 数据库配置（必须） =================
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_DATABASE=chatai

# ================= 搜索引擎配置（可选，用于网络搜索） =================
SEARCH_ENGINE_BASE_URL=https://google.serper.dev/search
SEARCH_ENGINE_API_KEYS=your-google-key

# ================= URL 爬虫配置（可选） =================
URL_CRAWLER_BASE_URL=http://your-crawler-api
URL_CRAWLER_API_KEYS=your-api-key
URL_CRAWLER_MAX_TOKENS=100000

# ================= Agent 迭代限制 =================
PLANNER_MAX_ITERATION=40
INFORMATION_SEEKER_MAX_ITERATION=30
WRITER_MAX_ITERATION=40
PLANNER_MODE=writing

# ================= 路径配置 =================
TRAJECTORY_STORAGE_PATH=./workspace
REPORT_OUTPUT_PATH=./report
```

### 5. 初始化数据库

```bash
# 创建数据库并导入表结构
mysql -u root -p < chatAi/chatai.sql
```

### 6. 配置 MCP 服务器

编辑 `deepdiver_v2/src/tools/server_config.yaml` 文件：

```yaml
server:
  host: 127.0.0.1
  port: 6274
  session_ttl_seconds: 3600
  max_sessions: 1000
  rate_limit_requests_per_minute: 300

tool_rate_limits:
  batch_web_search:
    requests_per_minute: 60
    requests_per_hour: 500
  url_crawler:
    requests_per_minute: 30
    requests_per_hour: 300
```

### 7. 配置字体（可选，用于 PDF 生成）

编辑 `deepdiver_v2/src/tools/mcp_tools.py` 文件，找到字体路径配置并设置正确的字体文件路径：

```python
# macOS 字体路径示例
simsun_path = "/System/Library/Fonts/PingFang.ttc"
simhei_path = "/System/Library/Fonts/PingFang.ttc"
arial_path = "/Library/Fonts/Arial.ttf"
symbol_path = "/System/Library/Fonts/Helvetica.ttc"

# Linux 字体路径
# simsun_path = "/usr/share/fonts/dejavu/SIMSUN.TTC"
# simhei_path = "/usr/share/fonts/dejavu/SIMHEI.TTF"
# arial_path = "/usr/share/fonts/dejavu/ARIAL.TTF"
# symbol_path = "/usr/share/fonts/dejavu/DejaVuSans.ttf"

# Windows 字体路径
# simsun_path = "C:/Windows/Fonts/simsun.ttc"
# simhei_path = "C:/Windows/Fonts/simhei.ttf"
# arial_path = "C:/Windows/Fonts/arial.ttf"
# symbol_path = "C:/Windows/Fonts/symbol.ttf"
```

---

## 启动服务

需要启动 3 个服务，请分别在不同的终端中运行：

### 服务 1：MCP 服务器（搜索服务）

```bash
cd deepdiver_v2
python src/tools/mcp_server_standard.py --config src/tools/server_config.yaml
```

### 服务 2：Flask Web API（用户管理、会话管理）

```bash
# 在新终端中运行
python app.py
```

### 服务 3：PlannerAgent HTTP 服务器（智能体任务处理）

```bash
# 在新终端中运行
cd deepdiver_v2
python cli/a.py
```

---

## 访问 Web 界面

打开浏览器访问：`http://localhost:5000/ai_chat.html`

首次使用需要注册账号，然后登录即可开始使用。

---

## 使用示例

### 场景 1：学术研究

1. 登录系统后，选择 **DeepDiver** 模式
2. 输入研究主题，例如："人工智能在医疗领域的应用"
3. 系统会自动进行网络搜索、文献检索
4. 生成结构化的研究报告，支持导出为 Markdown 或 PDF

### 场景 2：文档分析

1. 点击文档库，上传你的 PDF/Word 文档
2. 在对话框中上传文档或从文档库选择
3. 输入分析需求，例如："总结这篇论文的核心观点"
4. 系统会分析文档内容并生成摘要

### 场景 3：文献综述

1. 选择 **DeepDiver** 模式
2. 输入综述主题，例如："深度学习在自然语言处理中的发展"
3. 启用网络搜索功能
4. 系统会自动搜索相关文献并生成综述报告

---

## 端口说明

- **5000** - Flask Web API（主服务）
- **6274** - MCP 服务器（搜索服务）
- **8000** - PlannerAgent HTTP 服务器（智能体服务）

确保这些端口未被占用，如果需要修改端口，请编辑相应的配置文件。

---

## 常见问题

**Q: 提示数据库连接失败？**
A: 检查 MySQL 服务是否启动，数据库配置是否正确。

**Q: 提示 LLM API 连接失败？**
A: 检查 `deepdiver_v2/config/.env` 中的 `MODEL_REQUEST_URL` 和 `MODEL_REQUEST_TOKEN` 是否配置正确。

**Q: 搜索功能不工作？**
A: 需要配置搜索引擎 API（如 Google Custom Search），否则只能使用本地文档库。

**Q: PDF 导出乱码？**
A: 检查字体路径配置是否正确，确保系统已安装中文字体。

**Q: 如何停止服务？**
A: 在各个终端按 `Ctrl+C` 停止对应的服务。

---

## 工作模式说明

### Chat (普通对话)
- 标准的 LLM 对话模式
- 直接与大模型交互
- 适合日常问答和简单对话

### Reasoner (深度推理)
- 针对支持"思维链 (Chain of Thought)" 的模型设计
- 如 DeepSeek-R1, Pangu-Reasoner
- 界面会展示模型的思考/推理过程 (reasoning_content)
- 适合需要深度推理的复杂问题

### DeepDiver (万字长文)
- 调用后端 Multi-Agent 系统
- 执行复杂的长文写作和深度信息检索任务
- 适合学术研究、文献综述、报告生成等

---

## API 快速参考

### 用户认证
```bash
# 注册
POST /api/register

# 登录
POST /api/login
```

### 会话管理
```bash
# 创建会话
POST /api/chat/sessions

# 获取会话列表
GET /api/chat/sessions/<user_id>

# 删除会话
DELETE /api/chat/sessions/<session_id>
```

### 文档管理
```bash
# 上传文档
POST /api/context/upload

# 获取文档列表
GET /api/files/list/<user_id>

# 删除文档
DELETE /api/files/delete/<file_id>
```

### 报告下载
```bash
# 下载 PDF 报告
GET /api/download_pdf?session_id=<session-id>

# 下载 Markdown 报告
GET /api/download_md?session_id=<session-id>
```

### PlannerAgent 服务
```bash
# 处理查询
POST http://localhost:8000/api/query

# 获取任务状态
GET http://localhost:8000/api/task/{task_id}

# 取消任务
POST http://localhost:8000/api/task/{task_id}/cancel
```

---

## 技术支持

如有问题，请访问：https://github.com/cinastanbean/SciAssistant/issues
