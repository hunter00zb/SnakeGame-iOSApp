# SnakeGame-iOSApp

<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**贪食蛇** - 一个简洁优雅的 iOS 贪食蛇游戏

<img width="1080" height="2134" alt="wecom-temp-145217-d9c7b99f3efb55a6fe1272c3b5fdb69b" src="https://github.com/user-attachments/assets/48ce2cb8-08be-4a50-8cd1-e9cbd04dd85c" />


[功能特点](#功能特点) • [快速开始](#快速开始) • [项目结构](#项目结构) • [开发指南](#开发指南) • [更新日志](#更新日志)

</div>

---

## 功能特点

- **经典玩法** - 传统贪食蛇游戏，滑动控制方向
- **触控操作** - 支持滑动和点击操作
- **穿墙机制** - 四壁可穿越，咬到自己时游戏结束
- **速度递增** - 每吃 3 个食物加速一次
- **分数系统** - 实时分数和最高分记录
- **暂停功能** - 双击任意位置暂停/继续
- **精美界面** - 现代深色主题，渐变效果

---

## 快速开始

### 环境要求

- Xcode 14.0+
- iOS 13.0+
- Swift 5.0+

### 安装运行

1. **克隆项目**
   ```bash
   git clone https://github.com/hunter00zb/SnakeGame-iOSApp.git
   cd SnakeGame-iOSApp
   ```

2. **安装依赖**
   ```bash
   cd App
   npm install
   npx cap sync ios
   ```

3. **打开 Xcode**
   ```bash
   open App/App.xcworkspace
   ```

4. **运行项目**
   - 在 Xcode 中选择目标设备和模拟器
   - 点击运行按钮 (⌘+R)

---

## 项目结构

```
SnakeGame-iOSApp/
├── App/                          # iOS 应用主目录
│   ├── App/                      # Swift 源代码
│   │   ├── AppDelegate.swift      # 应用入口
│   │   ├── SceneDelegate.swift    # 场景管理
│   │   ├── GameViewController.swift # 游戏主逻辑
│   │   ├── Assets.xcassets/      # 图片资源
│   │   ├── Base.lproj/            # 故事板
│   │   └── public/                # Web 资源
│   ├── App.xcworkspace/          # Xcode 工作区
│   ├── App.xcodeproj/            # Xcode 项目
│   ├── Podfile                   # CocoaPods 依赖
│   └── capacitor.config.json     # Capacitor 配置
├── capacitor-cordova-ios-plugins/ # Cordova 插件
└── README.md                     # 项目说明
```

---

## 游戏规则

- 🎮 **开始游戏**: 点击"开始游戏"按钮或双击游戏区域
- ⬆️⬇️⬅️➡️ **控制方向**: 在游戏区域滑动控制蛇的移动方向
- 🍎 **吃食物**: 红色食物可让蛇变长
- ⚡ **加速**: 每吃 3 个食物速度增加 5%
- 🧱 **穿墙**: 四壁可以穿越
- 💀 **结束**: 只有咬到自己时游戏才会结束
- ⏸️ **暂停**: 双击任意位置暂停游戏

---

## 开发指南

### 添加新功能

1. 创建功能分支
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. 编写代码并提交
   ```bash
   git add .
   git commit -m "feat: 添加新功能描述"
   ```

3. 推送到远程
   ```bash
   git push origin feature/your-feature-name
   ```

### 构建发布

1. 更新版本号 (`Info.plist`)
2. 归档项目 (Product → Archive)
3. 导出 IPA 文件
4. 使用 Xcode 部署或 TestFlight 分发

---

## 技术栈

| 技术 | 说明 |
|------|------|
| Swift | 编程语言 |
| UIKit | 用户界面框架 |
| Capacitor | 跨平台桥接 |
| Xcode | 开发工具 |

---

## 更新日志

所有变更记录在 [CHANGELOG.md](CHANGELOG.md) 文件中。

---

## 贡献指南

欢迎提交 Issue 和 Pull Request！

请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献流程。

---

## 许可证

本项目基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

---

## 作者

**Hunter.Zong**

- GitHub: [@hunter00zb](https://github.com/hunter00zb)

---

<div align="center">

⭐ 如果这个项目对你有帮助，请 star 支持一下！

</div>
