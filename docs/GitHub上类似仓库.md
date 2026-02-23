# GitHub上类似仓库
        
'''    
toolName: web_search  
      
status: success
       
query: GitHub multi-agent ReAct planner writer information seeker AI assistant
'''
   
基于搜索结果，GitHub 上确实有多个类似功能的项目。让我为您总结一下：

## GitHub 上类似功能的仓库

### **1. DeepDiver-V2（华为开源）**

**仓库地址**：https://ai.gitcode.com/ascend-tribe/openPangu-Embedded-7B-DeepDiver

**架构特点**：
- **Planner 为中心**：以 Planner（规划器）为中心，协调多个 Executor（执行器）
- **Multi-Agent System**：多智能体系统架构
- **自适应复杂度评估**：Planner 接到复杂查询后，会进行自适应复杂度评估
- **任务分解**：将复杂任务分解为可执行的子任务

**与当前项目的相似性**：
- ✅ 都使用 PlannerAgent 进行任务规划和协调
- ✅ 都使用 ReAct 模式
- ✅ 都支持多智能体协作
- ✅ 都有任务分解和并行执行能力

---

### **2. 天工万象（蚂蚁集团）**

**架构特点**：
- **Multi-Agent 架构**：基于 Multi-Agent 架构的智能体
- **LangGraph 实现**：底层基于 LangGraph 实现
- **ReAct 范式**：每个子 Agent 都基于 ReAct 范式实现
- **自我反思和规划**：支持自我反思和自主规划工具使用
- **专业化智能体**：
  - 网页开发专家（中后台页面+静态网页）
  - 同业小 qiu（针对同业数据分析）
  - 全能小助手（通用性任务处理）

**与当前项目的相似性**：
- ✅ 都使用 Multi-Agent 架构
- ✅ 都使用 ReAct 模式
- ✅ 都有专业化分工（不同智能体负责不同任务）
- ✅ 都支持工具调用

---

### **3. AutoGPT**

**特点**：
- **2023 年出现**：标志着 Agent 进入新阶段
- **复杂任务处理**：能够完成复杂的项目任务
- **自主决策和工具调用**：具备自主决策和工具调用能力

**与当前项目的相似性**：
- ✅ 都使用 LLM 进行推理
- ✅ 都支持工具调用
- ✅ 都能处理复杂任务

---

### **4. ChatDev 框架**

**论文来源**：《Communicative Agents for Software Development》

**特点**：
- **软件开发方法**：利用 LLMs 来简化和统一软件开发的关键过程
- **自然语言沟通**：通过自然语言引导软件代理完成整个软件开发生命周期
- **多 Agent 协作**：支持多个 Agent 协同工作

**与当前项目的相似性**：
- ✅ 都使用 LLM
- ✅ 都支持多 Agent 协作
- ✅ 都通过自然语言交互

---

### **5. 其他相关研究**

#### **Multi-Agent Context Engineering（多智能体上下文工程）**

**核心概念**：
- **动态构建、共享、演化和优化上下文信息**
- **支持协同决策、任务分解、角色分配与冲突解决**
- **情境感知能力**：自动协调冲突或填补信息缺口

#### **Multi-Agent Collaboration（多智能体协作）**

**研究方向**：
- **多个 AI Agent 协同工作**
- **每个 Agent 有自己的角色和职责**
- **通过通信和协作来共同达成目标**
- **提高系统的效率和智能性**

---

## 总结对比

| 特性 | SciAssistant（当前项目）| DeepDiver-V2 | 天工万象 | AutoGPT |
|------|----------------------|---------------|---------|---------|
| **架构** | Multi-Agent + ReAct | Multi-Agent + Planner | Multi-Agent + LangGraph | Multi-Agent |
| **核心模式** | ReAct | ReAct | ReAct | ReAct |
| **任务协调** | PlannerAgent | Planner | LangGraph | - |
| **智能体类型** | Planner, InfoSeeker, Writer | Planner, Executor | 网页专家, 数据分析, 全能助手 | - |
| **并行执行** | ✅ 支持 | ✅ 支持 | ✅ 支持 | ✅ 支持 |
| **工具调用** | ✅ 支持 | ✅ 支持 | ✅ 支持 | ✅ 支持 |
| **开源状态** | ✅ 开源 | ✅ 开源 | ✅ 开源 | ❌ 闭源 |
| **公司/组织** | 南海所 | 华为 | 蚂蚁集团 | - |

## 结论

您的 SciAssistant 项目在 GitHub 上确实有多个类似功能的仓库，其中 **DeepDiver-V2** 和 **天工万象** 与您的项目最为相似：

1. **DeepDiver-V2**：同样是华为开源项目，使用 PlannerAgent 协调多个 Executor
2. **天工万象**：同样是 Multi-Agent 架构，使用 ReAct 模式和 LangGraph

这些项目都采用了 **Multi-Agent + ReAct** 的架构模式，与您的 SciAssistant 项目非常相似！