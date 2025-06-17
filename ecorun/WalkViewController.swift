import UIKit
import MapKit
import CoreLocation
import Lottie

class WalkViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var personMarker: UIImageView!
    @IBOutlet weak var lottieWalker: AnimationView!
    @IBOutlet weak var guideLeftLabel: UILabel!
    @IBOutlet weak var guideCenterLabel: UILabel!
    @IBOutlet weak var guideRightLabel: UILabel!

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var trackingTimer: Timer?
    private var elapsedSeconds = 0
    private var isPaused = false
    private var totalDistance: CLLocationDistance = 0
    private var lastLocation: CLLocation?
    private var firstFix = true
    private var maxDistance: CLLocationDistance = 1000
    private var progressWidth: CGFloat = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLocation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // capture progress view width for marker animation
        progressWidth = progressView.bounds.width
    }

    // MARK: - Configuration
    private func configureUI() {
        stopButton.isHidden = true
        pauseButton.isHidden = true
        timerLabel.isHidden = true
        lottieWalker.isHidden = true
        personMarker.isHidden = true

        progressView.progress = 0

        guideLeftLabel.text = "0m"
        updateGuideLabels()

        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    private func configureLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - IBActions
    @IBAction func startTapped(_ sender: UIButton) {
        showDistanceInputAlert()
    }

    @IBAction func pauseTapped(_ sender: UIButton) {
        isPaused.toggle()
        if isPaused {
            pauseTracking()
            pauseButton.setTitle("계속할게요", for: .normal)
            lottieWalker.pause()
        } else {
            resumeTracking()
            pauseButton.setTitle("잠깐 쉴게요", for: .normal)
            lottieWalker.play()
        }
    }

    @IBAction func stopTapped(_ sender: UIButton) {
        endSession()
        
    }

    // MARK: - Alerts
    private func showDistanceInputAlert() {
        let alert = UIAlertController(title: "목표 거리(m)를 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "예: 500"
            tf.keyboardType = .numberPad
            tf.text = "500"
            tf.textAlignment = .center
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "시작", style: .default) { _ in
            let text = alert.textFields?.first?.text ?? "1000"
            if let val = Double(text) { self.maxDistance = val }
            self.initializeSession()
        })
        present(alert, animated: true)
    }

    // MARK: - Session Control
    private func initializeSession() {
        // reset
        totalDistance = 0
        elapsedSeconds = 0
        lastLocation = nil
        firstFix = true

        // UI
        startButton.isHidden = true
        stopButton.isHidden = false
        pauseButton.isHidden = false
        timerLabel.isHidden = false
        lottieWalker.isHidden = false
        personMarker.isHidden = false
        lottieWalker.play()

        progressView.progress = 0
        updateGuideLabels()

        startTimer()
        updateStats()
        startLocationUpdates()
    }

    private func pauseTracking() {
        trackingTimer?.invalidate()
        locationManager.stopUpdatingLocation()
    }

    private func resumeTracking() {
        startTimer(reset: false)
        locationManager.startUpdatingLocation()
    }

    private func endSession() {
        // 1) 트래킹·애니메이션 멈추기
        pauseTracking()
        lottieWalker.stop()

        // 2) 결과 계산
        let distanceMeters = Int(totalDistance)
        let reducedCarbon = CarbonSource.walk.calculateCarbon(amount: distanceMeters)

        // 3) 저장
        CarbonStorage.shared.addCarbon(amount: reducedCarbon)

        // 4) Reward 화면 인스턴스화 & 값 주입
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let rewardVC = sb
            .instantiateViewController(withIdentifier: "RewardVC") as? RewardViewController
        else { return }

        rewardVC.carbonAmount   = reducedCarbon
        rewardVC.distance       = distanceMeters
        rewardVC.elapsedSeconds = elapsedSeconds
        rewardVC.source         = .walk

        // 5) 화면 전환 (push)
        navigationController?.pushViewController(rewardVC, animated: true)
    }

    // MARK: - Timer
    private func startTimer(reset: Bool = true) {
        if reset { elapsedSeconds = 0 }
        timerLabel.text = formattedTime(elapsedSeconds)
        trackingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedSeconds += 1
            self.timerLabel.text = self.formattedTime(self.elapsedSeconds)
        }
    }

    private func formattedTime(_ sec: Int) -> String {
        let h = sec / 3600, m = (sec % 3600) / 60, s = sec % 60
        return String(format: "시간: %02d:%02d:%02d", h, m, s)
    }

    // MARK: - Location Updates
    private func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }

    private func updateGuideLabels() {
        let center = maxDistance / 2
        guideCenterLabel.text = center >= 1000 ? String(format: "%.1fkm", center/1000) : String(format: "%.0fm", center)
        guideRightLabel.text = maxDistance >= 1000 ? String(format: "%.1fkm", maxDistance/1000) : String(format: "%.0fm", maxDistance)
    }
}

// MARK: - CLLocationManagerDelegate
extension WalkViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            guard loc.horizontalAccuracy <= 30 else { continue }
            if firstFix {
                mapView.setRegion(MKCoordinateRegion(center: loc.coordinate,
                                                     latitudinalMeters: 500,
                                                     longitudinalMeters: 500), animated: true)
                firstFix = false
            }
            if let last = lastLocation {
                let dist = last.distance(from: loc)
                if dist < 0.5 || dist > 100 { lastLocation = loc; continue }
                totalDistance += dist
                updateStats()
            }
            lastLocation = loc
        }
    }

    private func updateStats() {
        // distance label
        let display = totalDistance >= 1000 ? String(format: "%.1f km", totalDistance/1000) : String(format: "%.0f m", totalDistance)
        distanceLabel.text = "이동 거리: \(display)"
        // progress
        let prog = Float(min(totalDistance / maxDistance, 1.0))
        progressView.setProgress(prog, animated: true)
        // marker position
        let x = progressView.frame.minX + CGFloat(prog) * progressWidth
        personMarker.center.x = x
    }
}

// MARK: - MKMapViewDelegate
extension WalkViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let r = MKPolylineRenderer(overlay: overlay)
        r.strokeColor = .systemBlue
        r.lineWidth = 4
        return r
    }
}
