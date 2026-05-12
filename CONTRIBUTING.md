# 贡献指南

感谢您对 SnakeGame-iOSApp 项目的兴趣！我们欢迎各种形式的贡献。

## 如何贡献

### 报告问题

如果您发现任何问题或有功能建议，请：

1. 搜索现有 [Issues](https://github.com/hunter00zb/SnakeGame-iOSApp/issues) 确保问题未被报告
2. 创建新的 Issue，包含：
   - 清晰的标题和描述
   - 复现问题的步骤
   - 您的环境信息（iOS 版本、Xcode 版本等）
   - 相关的截图或日志

### 提交代码

1. **Fork 本仓库**
2. **创建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或修复分支
   git checkout -b fix/your-bug-fix
   ```
3. **提交您的更改**
   ```bash
   git commit -m "feat: 添加新功能"
   # 或
   git commit -m "fix: 修复问题"
   ```
4. **推送到您的 Fork**
   ```bash
   git push origin feature/your-feature-name
   ```
5. **创建 Pull Request**

### 提交信息规范

请使用以下前缀：

- `feat:` - 新功能
- `fix:` - 错误修复
- `docs:` - 文档更改
- `style:` - 代码格式（不影响功能）
- `refactor:` - 重构
- `perf:` - 性能优化
- `test:` - 测试相关
- `chore:` - 构建或辅助工具变动

示例：
```
feat: 添加新皮肤系统
fix: 修复暂停后分数显示错误
docs: 更新 README 说明
```

## 开发设置

```bash
# 克隆您的 Fork
git clone https://github.com/YOUR_USERNAME/SnakeGame-iOSApp.git

# 进入目录
cd SnakeGame-iOSApp

# 添加上游仓库
git remote add upstream https://github.com/hunter00zb/SnakeGame-iOSApp.git

# 创建开发分支
git checkout -b develop
```

## 代码规范

- 遵循 Swift 代码规范
- 使用有意义的变量和函数命名
- 添加必要的注释说明复杂逻辑
- 确保代码通过 Xcode 的静态分析

## 测试

在提交 PR 之前，请确保：

- [ ] 新功能已测试
- [ ] 没有引入新的编译警告
- [ ] 代码格式正确

## 许可证

通过贡献代码，您同意将您的作品按照 [MIT 许可证](LICENSE) 的条款发布。

---

再次感谢您的贡献！🎉
