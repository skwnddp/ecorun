import UIKit
import Lottie

class RewardViewController: UIViewController {
    // MARK: – Properties (값 전달)
    var carbonAmount: Int!
    var earnedPoints: Int!
    var distance: Int!
    var elapsedSeconds: Int!
    var source: CarbonSource!    // 이전 enum

    // MARK: – IBOutlets
    @IBOutlet weak var tvResult: UILabel!
    @IBOutlet weak var btnBackToMain: UIButton!
    @IBOutlet weak var lottie: AnimationView!
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        btnBackToMain.layer.cornerRadius = 10
        btnBackToMain.clipsToBounds = true
        setupLottie()

        // 1) 값을 보장하라

        // 2) 이전 총합 & 단계
        let prevTotal     = CarbonStorage.shared.totalCarbon()
        let previousStage = CarbonStorage.shared.stage(for: prevTotal)

        // 3) 저장
        CarbonStorage.shared.addCarbon(amount: carbonAmount)

        // 4) 새 총합 & 단계
        let newTotal     = prevTotal + carbonAmount
        let currentStage = CarbonStorage.shared.stage(for: newTotal)

        // 5) 단계 변경 시 축하 Alert
        if currentStage > previousStage {
            let message = "🎉 새싹 단계가\n\(previousStage)단계에서 \(currentStage)단계로\n쑥쑥 성장했어요!"
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert)
            present(alert, animated: true) {
                // 자동 닫기
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }

        // 6) 결과 텍스트 구성 & 표시
        let resultText: String
        if source.type == .recycle {
            resultText = """
            📦 분리배출 항목: \(source.displayName)
            🌱 탄소 절감량: \(carbonAmount!)g
            """
        } else {
            // 운동일 때
            let timeStr = formatTime(elapsedSeconds)
            resultText = """
            🏃 운동 기록
            🛣 이동 거리: \(distance!)m
            ⏱ 소요 시간: \(timeStr)
            🌱 탄소 절감량: \(carbonAmount!)g
            """
        }
        tvResult.text = resultText

        // 7) 뒤로가기 버튼
        btnBackToMain.addTarget(self,
                                action: #selector(backToHome),
                                for: .touchUpInside)
    }

    // MARK: – Helpers
    private func formatTime(_ sec: Int) -> String {
        let h = sec / 3600
        let m = (sec % 3600) / 60
        let s = sec % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    private func setupLottie() {
        lottie.animation = Animation.named("reward")
        lottie.backgroundColor = .clear
        lottie.isOpaque = false
        lottie.loopMode  = .loop
        lottie.play()
    }

    @objc private func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}
