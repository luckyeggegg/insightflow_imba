# 🕒 Glue Crawler 调度配置指南

## 调度方案对比

### 1. ⭐ **Glue Crawler 内置调度** (推荐)

#### 优势：
- ✅ **最简洁**：无需额外的 Lambda 或 EventBridge 资源
- ✅ **成本最低**：没有额外的计算成本
- ✅ **维护简单**：一个配置参数搞定
- ✅ **AWS 原生**：完全集成在 Glue 服务中
- ✅ **可靠性高**：AWS 管理的调度机制

#### 配置示例：
```hcl
# 在 main.tf 中
crawler_schedule = "cron(0 2 1 * ? *)"  # 每月1号凌晨2点
```

#### Cron 表达式格式：
```
cron(Minutes Hours Day-of-month Month Day-of-week Year)
```

#### 常用调度模式：
```hcl
# 每天运行
crawler_schedule = "cron(0 2 * * ? *)"     # 每天凌晨2点

# 每周运行
crawler_schedule = "cron(0 2 ? * SUN *)"   # 每周日凌晨2点

# 每月运行（推荐，匹配你的批处理）
crawler_schedule = "cron(0 2 1 * ? *)"     # 每月1号凌晨2点

# 工作日运行
crawler_schedule = "cron(0 2 ? * MON-FRI *)" # 工作日凌晨2点

# 手动执行
crawler_schedule = null                     # 只手动触发
```

### 2. 🔧 **EventBridge + Lambda** (你之前使用的)

#### 优势：
- ✅ **灵活性高**：可以加入自定义逻辑
- ✅ **条件执行**：可以检查数据是否更新
- ✅ **通知功能**：可以发送成功/失败通知
- ✅ **多步骤**：可以按顺序启动多个 crawler

#### 劣势：
- ❌ **复杂性高**：需要更多资源和代码
- ❌ **成本更高**：Lambda 执行成本
- ❌ **维护工作量**：需要维护 Lambda 代码

### 3. 🏗️ **EventBridge 直接调用**

#### 适中的解决方案：
```hcl
resource "aws_cloudwatch_event_rule" "crawler_trigger" {
  name                = "trigger-glue-crawlers"
  description         = "Trigger Glue crawlers monthly"
  schedule_expression = "cron(0 2 1 * ? *)"
}

resource "aws_cloudwatch_event_target" "crawler_target" {
  for_each = toset(["orders", "products", "departments", "aisles"])
  
  rule      = aws_cloudwatch_event_rule.crawler_trigger.name
  target_id = "GlueCrawlerTarget-${each.value}"
  arn       = "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:crawler/${var.env}_crawler_raw_${each.value}"
  
  role_arn = aws_iam_role.eventbridge_glue_role.arn
}
```

## 🎯 为你的场景推荐的配置

### 基于你的批处理模式：

#### 当前情况：
- **批处理时间**：每月30号悉尼时间0点（UTC 14点）
- **数据上传完成**：大约 30-60 分钟后
- **Crawler 最佳时间**：批处理完成后 1-2 小时

#### 推荐调度：
```hcl
# 选项1：每月1号凌晨2点UTC（批处理后约12小时）
crawler_schedule = "cron(0 2 1 * ? *)"

# 选项2：每月30号晚上（批处理后约6小时）  
crawler_schedule = "cron(0 20 30 * ? *)"

# 选项3：手动触发（最大控制权）
crawler_schedule = null
```

## 📋 时间线对比

### 自动调度模式：
```
月30号 14:00 UTC → 批处理开始
月30号 15:00 UTC → 数据上传完成
次月1号 02:00 UTC → Crawler 自动运行 ✅
次月1号 02:30 UTC → 表结构更新完成
```

### 手动模式：
```
月30号 14:00 UTC → 批处理开始
月30号 15:00 UTC → 数据上传完成
任意时间 → 手动触发 Crawler ✅
运行后 30分钟 → 表结构更新完成
```

## 🚀 立即行动建议

### 1. **短期**（当前测试阶段）：
```hcl
crawler_schedule = null  # 手动执行，便于测试
```

### 2. **生产环境**：
```hcl
crawler_schedule = "cron(0 2 1 * ? *)"  # 自动化，每月1号凌晨2点
```

### 3. **监控和通知**（可选增强）：
- 添加 CloudWatch 告警监控 Crawler 状态
- 使用 SNS 发送成功/失败通知

## 💡 最佳实践

1. **避免重叠**：确保 Crawler 在批处理完成后运行
2. **错开时间**：如果有多个环境，错开调度时间
3. **监控依赖**：批处理失败时，考虑跳过 Crawler
4. **测试优先**：先在测试环境验证调度时间
5. **日志记录**：启用 CloudWatch 日志便于故障排除
