import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    private let gridSize = 20
    private let cellSize: CGFloat = 20
    private var gameTimer: Timer?
    
    private var snake: [(Int, Int)] = []
    private var direction: (Int, Int) = (1, 0)
    private var nextDirection: (Int, Int) = (1, 0)
    private var food: (Int, Int) = (0, 0)
    private var score: Int = 0
    private var highScore: Int = 0
    private var isGameRunning: Bool = false
    private var isPaused: Bool = false
    private var tickInterval: TimeInterval = 0.2
    private let initialTickInterval: TimeInterval = 0.2
    private var foodEatenCount: Int = 0
    private let foodsPerSpeedUp: Int = 3
    private let speedUpPercent: Double = 0.05
    
    private let highScoreKey = "snake-high-score"
    
    // MARK: - UI Elements
    private var gameCanvas: UIView!
    private var touchArea: UIView!  // 游戏窗口+按钮区域的可触摸容器
    private var spacerView: UIView!  // 撑开触摸区域的透明视图
    private var titleLabel: UILabel!
    private var scoreLabel: UILabel!
    private var highScoreLabel: UILabel!
    private var overlayView: UIView!
    private var startButton: UIButton!
    private var exitButton: UIButton!
    private var overlayTitleLabel: UILabel!
    private var startTitleLabel: UILabel!
    private var rulesLabel: UILabel!
    private var creditLabel: UILabel!
    private var buttonContainer: UIView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHighScore()
        setupUI()
        resetGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawGame()
    }
    
    // MARK: - High Score
    private func loadHighScore() {
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    private func saveHighScore() {
        UserDefaults.standard.set(highScore, forKey: highScoreKey)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1.0)
        
        // Exit Button (top right)
        exitButton = UIButton(type: .system)
        exitButton.setTitle("退出", for: .normal)
        exitButton.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), for: .normal)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        // Title Label - 贪食蛇
        titleLabel = UILabel()
        titleLabel.text = "贪食蛇"
        titleLabel.textColor = UIColor(red: 0.24, green: 0.81, blue: 0.56, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Score & High Score Container
        let statsContainer = UIView()
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsContainer)
        
        scoreLabel = UILabel()
        scoreLabel.text = "得分 0"
        scoreLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        scoreLabel.font = UIFont.systemFont(ofSize: 16)
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(scoreLabel)
        
        highScoreLabel = UILabel()
        highScoreLabel.text = "最高 \(highScore)"
        highScoreLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        highScoreLabel.font = UIFont.systemFont(ofSize: 16)
        highScoreLabel.textAlignment = .left
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        statsContainer.addSubview(highScoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: statsContainer.centerYAnchor),
            highScoreLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor),
            highScoreLabel.centerYAnchor.constraint(equalTo: statsContainer.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: highScoreLabel.leadingAnchor, constant: -30)
        ])
        
        // Touch Area Container (覆盖游戏窗口+按钮区域)
        touchArea = UIView()
        touchArea.backgroundColor = .clear
        touchArea.isUserInteractionEnabled = true
        touchArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(touchArea)
        
        // Game Canvas
        gameCanvas = UIView()
        gameCanvas.backgroundColor = UIColor(red: 0.04, green: 0.055, blue: 0.08, alpha: 1.0)
        gameCanvas.layer.cornerRadius = 12
        gameCanvas.layer.borderWidth = 2
        gameCanvas.layer.borderColor = UIColor(red: 0.18, green: 0.23, blue: 0.31, alpha: 0.5).cgColor
        gameCanvas.translatesAutoresizingMaskIntoConstraints = false
        touchArea.addSubview(gameCanvas)
        
        // Overlay View (only shows when paused or game over)
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.layer.cornerRadius = 12
        overlayView.isUserInteractionEnabled = true
        overlayView.isHidden = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        gameCanvas.addSubview(overlayView)
        
        // Overlay Title Label (已暂停 / 游戏结束)
        overlayTitleLabel = UILabel()
        overlayTitleLabel.textColor = .white
        overlayTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        overlayTitleLabel.textAlignment = .center
        overlayTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(overlayTitleLabel)
        
        // Start Button Container (inside touch area)
        buttonContainer = UIView()
        buttonContainer.isUserInteractionEnabled = true
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        touchArea.addSubview(buttonContainer)
        
        // Overlay Title Label (点击开始 - outside game canvas)
        startTitleLabel = UILabel()
        startTitleLabel.text = "点击开始"
        startTitleLabel.textColor = .white
        startTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        startTitleLabel.textAlignment = .center
        startTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(startTitleLabel)
        
        // Start Button
        startButton = UIButton(type: .system)
        startButton.setTitle("开始游戏", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startButton.backgroundColor = UIColor(red: 0.24, green: 0.81, blue: 0.56, alpha: 1.0)
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(startButton)
        
        // Rules Label (inside buttonContainer, between game canvas and start title)
        rulesLabel = UILabel()
        rulesLabel.text = "吃到红色食物变长；四壁可穿越，只有咬到自己时游戏结束。双击任意位置暂停。"
        rulesLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        rulesLabel.font = UIFont.systemFont(ofSize: 13)
        rulesLabel.textAlignment = .center
        rulesLabel.numberOfLines = 0
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(rulesLabel)
        
        // Credit Label
        creditLabel = UILabel()
        creditLabel.text = "本游戏由 Hunter.Zong 个人开发"
        creditLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        creditLabel.font = UIFont.systemFont(ofSize: 12)
        creditLabel.textAlignment = .center
        creditLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditLabel)
        
        // Spacer View (撑开触摸区域到650pt高度)
        spacerView = UIView()
        spacerView.backgroundColor = .clear
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        touchArea.addSubview(spacerView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Touch Area - 覆盖游戏窗口+按钮区域（高度扩展到650pt）
            touchArea.topAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: 20),
            touchArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchArea.widthAnchor.constraint(equalToConstant: CGFloat(gridSize) * cellSize),
            touchArea.bottomAnchor.constraint(equalTo: spacerView.bottomAnchor),
            
            gameCanvas.topAnchor.constraint(equalTo: touchArea.topAnchor),
            gameCanvas.leadingAnchor.constraint(equalTo: touchArea.leadingAnchor),
            gameCanvas.widthAnchor.constraint(equalToConstant: CGFloat(gridSize) * cellSize),
            gameCanvas.heightAnchor.constraint(equalToConstant: CGFloat(gridSize) * cellSize),
            
            overlayView.topAnchor.constraint(equalTo: gameCanvas.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: gameCanvas.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: gameCanvas.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: gameCanvas.bottomAnchor),
            
            overlayTitleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            overlayTitleLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            
            // buttonContainer 保持在原位，不绑定到 touchArea 底部
            buttonContainer.topAnchor.constraint(equalTo: gameCanvas.bottomAnchor, constant: 20),
            buttonContainer.centerXAnchor.constraint(equalTo: touchArea.centerXAnchor),
            buttonContainer.widthAnchor.constraint(equalToConstant: 200),
            
            // spacerView 撑开触摸区域到700pt
            spacerView.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: touchArea.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: touchArea.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: touchArea.bottomAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 130),  // 700 - 570 = 130
            
            rulesLabel.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            rulesLabel.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
            rulesLabel.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
            
            startTitleLabel.topAnchor.constraint(equalTo: rulesLabel.bottomAnchor, constant: 12),
            startTitleLabel.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: startTitleLabel.bottomAnchor, constant: 16),
            startButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 140),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            startButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            
            creditLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            creditLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Gestures - 添加到触摸区域容器
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        touchArea.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        touchArea.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Game Logic
    private func resetGame() {
        snake = [(gridSize/2, gridSize/2), (gridSize/2 - 1, gridSize/2), (gridSize/2 - 2, gridSize/2)]
        direction = (1, 0)
        nextDirection = (1, 0)
        score = 0
        foodEatenCount = 0
        isGameRunning = false
        isPaused = false
        tickInterval = initialTickInterval
        updateScoreDisplay()
        placeFood()
        overlayView.isHidden = true
        drawGame()
    }
    
    private func placeFood() {
        var occupied: Set<String> = []
        for segment in snake {
            occupied.insert("\(segment.0),\(segment.1)")
        }
        
        var newFood: (Int, Int)
        repeat {
            newFood = (Int.random(in: 0..<gridSize), Int.random(in: 0..<gridSize))
        } while occupied.contains("\(newFood.0),\(newFood.1)")
        food = newFood
    }
    
    private func updateScoreDisplay() {
        scoreLabel.text = "得分 \(score)"
        highScoreLabel.text = "最高 \(highScore)"
    }
    
    @objc private func startButtonTapped() {
        if !isGameRunning {
            startGame()
        } else if isPaused {
            resumeGame()
        }
    }
    
    @objc private func exitButtonTapped() {
        gameTimer?.invalidate()
        isGameRunning = false
        isPaused = false
        buttonContainer.isHidden = false
        resetGame()
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if !isGameRunning {
            startGame()
        } else {
            togglePause()
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isGameRunning && !isPaused else { return }
        
        if gesture.state == .ended {
            let translation = gesture.translation(in: touchArea)
            let dx = translation.x
            let dy = translation.y
            
            if abs(dx) > abs(dy) {
                if dx > 0 && direction.0 != -1 {
                    nextDirection = (1, 0)
                } else if dx < 0 && direction.0 != 1 {
                    nextDirection = (-1, 0)
                }
            } else {
                if dy > 0 && direction.1 != -1 {
                    nextDirection = (0, 1)
                } else if dy < 0 && direction.1 != 1 {
                    nextDirection = (0, -1)
                }
            }
        }
    }
    
    private func startGame() {
        if isGameRunning || isPaused {
            return
        }
        if score > 0 {
            // Restart with new game
            snake = [(gridSize/2, gridSize/2), (gridSize/2 - 1, gridSize/2), (gridSize/2 - 2, gridSize/2)]
            direction = (1, 0)
            nextDirection = (1, 0)
            score = 0
            foodEatenCount = 0
            tickInterval = initialTickInterval
            placeFood()
            updateScoreDisplay()
        }
        isGameRunning = true
        isPaused = false
        // 隐藏开始按钮区域
        buttonContainer.isHidden = true
        gameTimer = Timer.scheduledTimer(timeInterval: tickInterval, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
    }
    
    private func pauseGame() {
        isPaused = true
        gameTimer?.invalidate()
        overlayView.isHidden = false
        overlayTitleLabel.text = "已暂停"
        buttonContainer.isHidden = true
    }
    
    private func resumeGame() {
        isPaused = false
        overlayView.isHidden = true
        buttonContainer.isHidden = true
        gameTimer = Timer.scheduledTimer(timeInterval: tickInterval, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
    }
    
    private func togglePause() {
        if isPaused {
            resumeGame()
        } else {
            pauseGame()
        }
    }
    
    @objc private func gameLoop() {
        direction = nextDirection
        moveSnake()
        drawGame()
    }
    
    private func moveSnake() {
        let head = snake[0]
        let newHead = (head.0 + direction.0, head.1 + direction.1)
        
        // Wrap around walls
        let wrappedHead = ((newHead.0 + gridSize) % gridSize, (newHead.1 + gridSize) % gridSize)
        
        // Check self collision
        var hitSelf = false
        for i in 0..<snake.count {
            if snake[i] == wrappedHead {
                hitSelf = true
                break
            }
        }
        
        if hitSelf {
            gameOver()
            return
        }
        
        snake.insert(wrappedHead, at: 0)
        
        // Check food collision
        if wrappedHead == food {
            score += 10
            foodEatenCount += 1
            if score > highScore {
                highScore = score
                saveHighScore()
            }
            
            // Speed up every 3 foods, max 100% faster
            if foodEatenCount % foodsPerSpeedUp == 0 {
                // Calculate max speed (50% of initial = 100% faster)
                let minInterval = initialTickInterval * 0.5
                // New interval = initial - (foodsEaten / 3) * 5% of initial
                let speedUpAmount = Double(foodEatenCount / foodsPerSpeedUp) * speedUpPercent * initialTickInterval
                let newInterval = max(minInterval, initialTickInterval - speedUpAmount)
                
                if newInterval != tickInterval {
                    tickInterval = newInterval
                    // Restart timer with new interval
                    gameTimer?.invalidate()
                    gameTimer = Timer.scheduledTimer(timeInterval: tickInterval, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
                }
            }
            
            placeFood()
            updateScoreDisplay()
        } else {
            snake.removeLast()
        }
    }
    
    private func gameOver() {
        gameTimer?.invalidate()
        isGameRunning = false
        foodEatenCount = 0
        overlayView.isHidden = false
        overlayTitleLabel.text = "游戏结束"
        buttonContainer.isHidden = false
    }
    
    // MARK: - Drawing
    private func drawGame() {
        // Clear previous drawings
        for subview in gameCanvas.subviews {
            if subview != overlayView {
                subview.removeFromSuperview()
            }
        }
        
        // Remove previous grid layers
        gameCanvas.layer.sublayers?.forEach { layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        // Draw grid
        drawGrid()
        
        // Draw snake
        for (index, segment) in snake.enumerated() {
            let segmentView = UIView()
            
            if index == 0 {
                // Head - lighter green
                segmentView.backgroundColor = UIColor(red: 0.4, green: 0.71, blue: 0.56, alpha: 1.0)
            } else {
                // Body - gradient from light to dark green
                let t = CGFloat(index) / CGFloat(max(snake.count - 1, 1))
                let r = CGFloat(0.24 + t * 0.1)
                let g = CGFloat(0.63 + t * 0.08)
                let b = CGFloat(0.4 + t * 0.1)
                segmentView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 0.85)
            }
            
            let pad: CGFloat = index == 0 ? 1 : 2
            segmentView.frame = CGRect(
                x: CGFloat(segment.0) * cellSize + pad,
                y: CGFloat(segment.1) * cellSize + pad,
                width: cellSize - pad * 2,
                height: cellSize - pad * 2
            )
            segmentView.layer.cornerRadius = index == 0 ? 5 : 3
            gameCanvas.addSubview(segmentView)
        }
        
        // Draw food with gradient effect
        drawFood()
    }
    
    private func drawGrid() {
        let gridLayer = CAShapeLayer()
        let path = UIBezierPath()
        let lineColor = UIColor(red: 0.18, green: 0.23, blue: 0.31, alpha: 0.35)
        gridLayer.strokeColor = lineColor.cgColor
        gridLayer.lineWidth = 0.5
        
        // Vertical lines
        for i in 0...gridSize {
            let x = CGFloat(i) * cellSize
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: CGFloat(gridSize) * cellSize))
        }
        
        // Horizontal lines
        for i in 0...gridSize {
            let y = CGFloat(i) * cellSize
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: CGFloat(gridSize) * cellSize, y: y))
        }
        
        gridLayer.path = path.cgPath
        gameCanvas.layer.insertSublayer(gridLayer, at: 0)
    }
    
    private func drawFood() {
        let foodView = UIView()
        
        // Gradient from light red to dark red
        foodView.frame = CGRect(
            x: CGFloat(food.0) * cellSize + 2,
            y: CGFloat(food.1) * cellSize + 2,
            width: cellSize - 4,
            height: cellSize - 4
        )
        foodView.layer.cornerRadius = 4
        
        // Add gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = foodView.bounds
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0).cgColor,
            UIColor(red: 0.79, green: 0.16, blue: 0.16, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.7)
        gradientLayer.cornerRadius = 4
        
        foodView.layer.insertSublayer(gradientLayer, at: 0)
        gameCanvas.addSubview(foodView)
    }
}
