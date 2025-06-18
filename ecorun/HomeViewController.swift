import UIKit
import Lottie

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var carbonLabel: UILabel!

    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!
    
    @IBOutlet weak var lottie: AnimationView!
    @IBOutlet weak var imageView: UIImageView!

    private let messages = [
        "안녕! 나는 고양이야 😺",
        "산책할 준비됐어?",
        "목표 거리를 설정해 줘!",
        "멈추려면 버튼 누르면 돼",
        "탄소를 절감해 보자! 🌱"
    ]
    private var msgIndex = 0
    private var bubble: SpeechBubbleView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "메인 화면"
        setupButtons()
        setupLottie()
        addSpeechBubble()
        animateBubble()
        
        imageView.image = UIImage(named: "world")
        imageView.contentMode = .scaleAspectFill
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLottie()
        updateCarbonInfo()
    }
    
    private func updateCarbonInfo() {
        let totalCarbon = CarbonStorage.shared.totalCarbon()
        let todayCarbon = CarbonStorage.shared.todayCarbon()
        let currentStage = CarbonStorage.shared.stage(for: totalCarbon)
        //🌱
        levelLabel.text = "🌱 새싹 \(currentStage) 단계"
        carbonLabel.text = "오늘의 탄소 절감량 : \(todayCarbon)g"
    }

    // MARK: - Private
    private func setupButtons() {
        let buttons: [UIButton?] = [walkButton, runButton, bikeButton, recycleButton]
        buttons.forEach { btn in
            guard let btn = btn else { return }
            // 버튼 둥글게
            btn.layer.cornerRadius = 10
            btn.clipsToBounds = true
            btn.titleLabel?.numberOfLines = 0
        }
    }

    // MARK: - IBActions
    @IBAction func walkButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WalkVC") as? WalkViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func runButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "RunVC") as? RunViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func bikeButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BikeVC") as? BikeViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func recycleButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "RecycleVC") as? RecycleViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupLottie() {
        lottie.animation = Animation.named("cat")
        lottie.backgroundColor = .clear
        lottie.isOpaque = false
        lottie.loopMode  = .loop
        lottie.play()
    }
    
    private func addSpeechBubble() {
        bubble = SpeechBubbleView(text: messages[msgIndex])
        // 크기 계산
        let w: CGFloat = 160, h: CGFloat = 60
        bubble.frame = CGRect(x: -w, y: imageView.frame.minY - h - 8, width: w, height: h)
        view.addSubview(bubble)
    }

    private func animateBubble() {
        let screenW = view.bounds.width
        let duration: TimeInterval = 4.0

        // 다음 메시지 준비
        func nextMessage() {
            msgIndex = (msgIndex + 1) % messages.count
            bubble.removeFromSuperview()
            addSpeechBubble()
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            self.bubble.frame.origin.x = screenW
        }, completion: { _ in
            nextMessage()
            // 재귀 호출로 루프
            self.animateBubble()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 스크린 너비 기준으로 타겟 사이즈 계산 (정사각형)
        let screenWidth = view.bounds.width
        let targetSize = screenWidth * 1.0
        
        // imageView 프레임 업데이트
        //   - 너비/높이를 동일하게 설정
        //   - 화면 아래 중앙에 배치
        imageView.frame.size = CGSize(width: targetSize, height: targetSize)
        imageView.center.x = view.bounds.midX
        imageView.frame.origin.y = view.bounds.maxY - (targetSize * 0.72)
        
        // 원형 마스크
        imageView.layer.cornerRadius = targetSize / 2
        imageView.layer.masksToBounds = true
        
        // 회전 애니메이션 (추가했다면)
        if imageView.layer.animation(forKey: "rotate") == nil {
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.fromValue = 0
            rotation.toValue   = CGFloat.pi * 2
            rotation.duration  = 48
            rotation.repeatCount = .infinity
            rotation.isRemovedOnCompletion = false
            imageView.layer.add(rotation, forKey: "rotate")
        }
    }
}
