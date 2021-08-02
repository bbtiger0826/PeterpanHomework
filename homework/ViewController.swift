import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var laRoundA: UILabel!
    @IBOutlet weak var laRoundB: UILabel!
    @IBOutlet weak var laScoreA: UILabel!
    @IBOutlet weak var laScoreB: UILabel!
    @IBOutlet weak var laServeA: UILabel!
    @IBOutlet weak var laServeB: UILabel!
    @IBOutlet weak var laRewind: UILabel!
    @IBOutlet weak var laChangeSide: UILabel!
    @IBOutlet weak var laReset: UILabel!
    
    var backgroundColor = UIColor.systemBlue // 背景顏色
    var firstServe = 0 // 目前是誰的先發局 (1: A, 2: B)
    var serveState = 0 // 目前誰發球 (1: A發球, 2: B發球)
    var serveCount = 0 // 發球次數
    var scoreA = 0 // A 計分
    var scoreB = 0 // B 計分
    var roundA = 0 // A 贏得局數
    var roundB = 0 // B 贏得局數
    var record = [Int]() // 紀錄 (1: A, 2: B)
    var playoff = false // 延長賽
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 開啟互動功能
        laScoreA.isUserInteractionEnabled = true
        laScoreB.isUserInteractionEnabled = true
        laChangeSide.isUserInteractionEnabled = true
        laRewind.isUserInteractionEnabled = true
        laReset.isUserInteractionEnabled = true
        // 點擊事件
        let clickScoreA = UITapGestureRecognizer.init(target: self, action: #selector(self.clickScoreA))
        let clickScoreB = UITapGestureRecognizer.init(target: self, action: #selector(self.clickScoreB))
        let clickChangeSide = UITapGestureRecognizer.init(target: self, action: #selector(self.clickChangeSide))
        let clickRewind = UITapGestureRecognizer.init(target: self, action: #selector(self.clickRewind))
        let clickReset = UITapGestureRecognizer.init(target: self, action: #selector(self.clickReset))
        // 綁定動作
        laScoreA.addGestureRecognizer(clickScoreA)
        laScoreB.addGestureRecognizer(clickScoreB)
        laChangeSide.addGestureRecognizer(clickChangeSide)
        laRewind.addGestureRecognizer(clickRewind)
        laReset.addGestureRecognizer(clickReset)
        // 開始遊戲
        gameStart();
    }
    
    // 開始遊戲
    func gameStart() {
        // A先發局
        firstServe = 1
        // A先發球
        serveState = 1
        
        updateGame()
        
    }
    
    // 更新遊戲
    func updateGame() {
        // 更新發球狀態
        if serveState % 2 != 0 {
            laServeA.textColor = UIColor.orange
            laServeB.textColor = backgroundColor
        }else {
            laServeA.textColor = backgroundColor
            laServeB.textColor = UIColor.orange
        }
        // 更新分數
        laScoreA.text = String(scoreA)
        laScoreB.text = String(scoreB)
        // 更新贏得的局數
        laRoundA.text = String(roundA)
        laRoundB.text = String(roundB)
    }
    
    // 新的一局
    func newRound() {
        // 清空延長賽狀態
        playoff = false
        // 清空儲存
        record.removeAll()
        // 清空計分
        scoreA = 0
        scoreB = 0
        // 清空 發球次數
        serveCount = 0
        // 換人先發局
        if firstServe % 2 != 0 {
            // 換B先發局
            firstServe = 2
            serveState = 2
        }else {
            // 換A先發局
            firstServe = 1
            serveState = 1
        }
    }
    // 是否進入延長賽
    func isPlayoff() {
        if scoreA >= 10 && scoreB >= 10 {
            playoff = true
        }else {
            playoff = false
        }
    }
    
    // 狀態判斷
    func stateJudgment() {
        // 是否進入延長賽
        isPlayoff()
        // 如果進入延長賽
        if playoff {
            // 每次都更換發球
            serveState = serveState + 1
        }else {
            // 如果發球方已經發2球了
            serveCount = serveCount + 1
            if serveCount >= 2 {
                serveCount = 0
                serveState = serveState + 1 // 換人發球
            }
        }
    }

    @objc func clickScoreA() {
        scoreA = scoreA + 1
        // 紀錄
        record.append(1)
        // 狀態判斷
        stateJudgment()
        // 檢查分數
        if playoff {
            // 檢查誰多贏2分
            if scoreA - scoreB == 2 {
                roundA = roundA + 1
                // 如果這局贏了 清空所有計分, 發球次數, 換人發球
                newRound()
            }
        }else {
            if scoreA >= 11 {
                roundA = roundA + 1
                // 如果這局贏了 清空所有計分, 發球次數, 換人發球
                newRound()
            }
        }
        // 更新遊戲
        updateGame()
    }
    
    @objc func clickScoreB() {
        scoreB = scoreB + 1
        // 紀錄
        record.append(2)
        // 狀態判斷
        stateJudgment()
        // 檢查分數
        if playoff {
            // 檢查有沒有多贏2分
            if scoreB - scoreA == 2 {
                roundA = roundA + 1
                // 如果這局贏了 清空所有計分, 發球次數, 換人發球
                newRound()
            }
        }else {
            if scoreB >= 11 {
                roundB = roundB + 1
                // 如果這局贏了 清空所有計分, 發球次數, 換人發球
                newRound()
            }
        }
        // 更新遊戲
        updateGame()
    }
    
    @objc func clickChangeSide() {
        if backgroundColor == UIColor.systemBlue {
            backgroundColor = UIColor.systemGreen
        }else {
            backgroundColor = UIColor.systemBlue
        }
        self.view.backgroundColor  = backgroundColor
        // 更新遊戲
        updateGame()
    }
    
    @objc func clickRewind() {
        //
        let rec =  record.last
        if rec == nil {
            return
        }
        // 是否進入延長賽
        isPlayoff()
        // 如果進入延長賽
        if playoff {
            // 還原狀態
            serveState = serveState - 1
        }else {
            // 還原狀態
            if serveCount == 0 {
                serveCount = 1
                serveState = serveState - 1
            }else {
                serveCount = serveCount - 1
            }
        }
        // 還原分數
        switch rec {
        case 1:
            scoreA = scoreA - 1
        case 2:
            scoreB = scoreB - 1
        default:
            break
        }
        record.removeLast()
        //
        updateGame()
    }
    
    @objc func clickReset() {
        // 清空延長賽狀態
        playoff = false
        // 清空儲存
        record.removeAll()
        // 清空計分
        scoreA = 0
        scoreB = 0
        // 清空 發球次數
        serveCount = 0
        // 是誰的先發局
        switch firstServe {
        case 1:
            serveState = 1
        case 2:
            serveState = 2
        default:
            break
        }
        //
        updateGame()
    }
}

