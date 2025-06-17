import UIKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var carbonLabel: UILabel!

    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "홈"
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCarbonInfo()
    }
    
    private func updateCarbonInfo() {
        let totalCarbon = CarbonStorage.shared.totalCarbon()
        let todayCarbon = CarbonStorage.shared.todayCarbon()
        let currentStage = CarbonStorage.shared.stage(for: totalCarbon)

        levelLabel.text = "🌱 새싹 \(currentStage) 단계"
        carbonLabel.text = "오늘의 탄소 절감량 : \(todayCarbon)g"
    }

    // MARK: - Private
    private func setupButtons() {
        let buttons: [UIButton?] = [walkButton, runButton, bikeButton, recycleButton]
        buttons.forEach { btn in
            guard let btn = btn else { return }
            // 버튼 둥글게
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
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

    @IBAction func infoButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "InfoVC") as? InfoViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
