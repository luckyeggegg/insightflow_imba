# ✅ 部署检查清单 (Deployment Checklist)

## 🚀 部署前准备

### 1. **环境验证**
- [ ] AWS CLI 已配置并能访问目标账户
- [ ] Terraform 已安装 (推荐 v1.0+)
- [ ] 工作目录：`terraform/dev/`
- [ ] 权限检查：IAM 用户具有 Glue、S3、IAM 创建权限

### 2. **配置文件检查**
- [ ] `terraform.tfvars` 中的值已正确设置
- [ ] `crawler_schedule` 设置符合需求：
  - 测试环境：`null` (手动执行)
  - 生产环境：`"cron(0 2 1 * ? *)"` (每月自动)
- [ ] S3 bucket 名称全球唯一性确认

### 3. **数据文件检查**
- [ ] 确认 `imba_data/` 目录下有以下文件：
  - [ ] `orders.csv`
  - [ ] `products.csv`
  - [ ] `departments.csv`
  - [ ] `aisles.csv`
  - [ ] `order_products__prior.csv.gz`
  - [ ] `order_products__train.csv.gz`

## 🔧 部署步骤

### 第一次部署

```powershell
# 1. 进入工作目录
cd terraform/dev

# 2. 初始化 Terraform
terraform init

# 3. 验证配置
terraform validate

# 4. 查看执行计划
terraform plan

# 5. 执行部署
terraform apply
```

### 预期创建的资源

#### S3 相关 (来自 s3_buckets 模块)
- [ ] `insightflow-raw-bucket`
- [ ] `insightflow-clean-bucket`
- [ ] 自动目录结构 (6个表的目录)

#### Glue 相关 (来自 glue_crawler_raw 模块)
- [ ] IAM Role: `{env}-glue-crawler-role`
- [ ] Glue Database: `{env}_raw_data_catalog`
- [ ] 6个 Glue Crawlers:
  - [ ] `{env}_crawler_raw_orders`
  - [ ] `{env}_crawler_raw_products`
  - [ ] `{env}_crawler_raw_departments`
  - [ ] `{env}_crawler_raw_aisles`
  - [ ] `{env}_crawler_raw_order_products_prior`
  - [ ] `{env}_crawler_raw_order_products_train`

#### 其他模块
- [ ] VPC 和网络资源
- [ ] RDS PostgreSQL 实例
- [ ] EC2 实例

## 🧪 部署后验证

### 1. **S3 结构验证**
```powershell
aws s3 ls s3://insightflow-raw-bucket/data/batch/ --recursive
```
**预期输出：**
```
2024-XX-XX XX:XX:XX     0 data/batch/orders/placeholder.txt
2024-XX-XX XX:XX:XX     0 data/batch/products/placeholder.txt
2024-XX-XX XX:XX:XX     0 data/batch/departments/placeholder.txt
2024-XX-XX XX:XX:XX     0 data/batch/aisles/placeholder.txt
2024-XX-XX XX:XX:XX     0 data/batch/order_products_prior/placeholder.txt
2024-XX-XX XX:XX:XX     0 data/batch/order_products_train/placeholder.txt
```

### 2. **Glue 资源验证**
```powershell
# 检查 Glue Database
aws glue get-database --name dev_raw_data_catalog

# 检查 Crawlers
aws glue get-crawlers --query 'CrawlerList[?contains(Name, `dev_crawler_raw`)].Name'
```

### 3. **数据上传测试**
```powershell
# 上传测试数据
./upload_data.ps1
```

### 4. **Crawler 手动执行测试**
```powershell
# 执行单个 crawler (例如：orders)
aws glue start-crawler --name "dev_crawler_raw_orders"

# 检查 crawler 状态
aws glue get-crawler --name "dev_crawler_raw_orders"

# 等待完成后检查表
aws glue get-tables --database-name "dev_raw_data_catalog"
```

## 🔍 故障排除

### 常见问题

#### 1. **S3 Bucket 创建失败**
```
Error: BucketAlreadyExists
```
**解决方案：** 修改 `terraform.tfvars` 中的 bucket 名称，确保全球唯一性

#### 2. **IAM 权限不足**
```
Error: AccessDenied
```
**解决方案：** 确认 AWS CLI 配置的用户具有以下权限：
- `IAMFullAccess`
- `AmazonS3FullAccess`
- `AWSGlueConsoleFullAccess`

#### 3. **Crawler 执行失败**
```
Error: Data source not found
```
**解决方案：** 确认 S3 目录结构正确，运行 `upload_data.ps1` 上传测试数据

#### 4. **依赖关系错误**
```
Error: Resource not found
```
**解决方案：** 检查模块之间的 `depends_on` 配置，确保 S3 buckets 先于 Glue crawlers 创建

### 调试命令

```powershell
# 查看 Terraform 状态
terraform state list

# 查看特定资源
terraform state show module.glue_crawler_raw.aws_glue_crawler.orders

# 查看 Terraform 日志
$env:TF_LOG="DEBUG"
terraform apply

# 检查 AWS 资源
aws s3api head-bucket --bucket insightflow-raw-bucket
aws glue get-crawlers
aws iam get-role --role-name dev-glue-crawler-role
```

## 📈 成功标准

### 部署成功后，应该看到：

1. **Terraform 输出**：
   ```
   Apply complete! Resources: XX added, 0 changed, 0 destroyed.
   
   Outputs:
   crawler_names = [
     "dev_crawler_raw_orders",
     "dev_crawler_raw_products",
     "dev_crawler_raw_departments", 
     "dev_crawler_raw_aisles",
     "dev_crawler_raw_order_products_prior",
     "dev_crawler_raw_order_products_train"
   ]
   ```

2. **AWS Glue Console**：
   - Database `dev_raw_data_catalog` 存在
   - 6个 Crawlers 状态为 "Ready"
   - 如果配置了调度，显示下次运行时间

3. **S3 Console**：
   - Raw bucket 存在完整目录结构
   - 每个目录包含 placeholder.txt

## 🎯 下一步计划

### 部署成功后：

1. **数据验证**：
   - [ ] 上传实际数据文件
   - [ ] 手动运行所有 crawlers
   - [ ] 验证生成的表结构

2. **DMS 集成**：
   - [ ] 更新 DMS 模块使用 Glue 表
   - [ ] 配置 DMS 任务
   - [ ] 测试数据同步到 RDS

3. **生产优化**：
   - [ ] 配置监控和告警
   - [ ] 优化 crawler 调度时间
   - [ ] 添加数据质量检查

---

**准备好了吗？运行 `terraform apply` 开始部署！** 🚀
