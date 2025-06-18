//
//  RecycleViewController.swift
//  ecorun
//
//  Created by mac on 2025/06/16.
//

import UIKit
import Lottie

class RecycleViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var btnPet: UIButton!
    @IBOutlet weak var btnCan: UIButton!
    @IBOutlet weak var btnGlass: UIButton!
    @IBOutlet weak var btnPaper: UIButton!
    @IBOutlet weak var lottie: AnimationView!
    @IBOutlet weak var ttt: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottie()
        navigationItem.title = "재활용 배출"
        
        [btnPet, btnCan, btnGlass, btnPaper].forEach { button in
            button?.layer.cornerRadius = 10
            button?.clipsToBounds = true
        }
    }

    // MARK: - IBActions
    @IBAction func petTapped(_ sender: UIButton) {
        showQuantityAlert(for: .recyclePet)
    }

    @IBAction func canTapped(_ sender: UIButton) {
        showQuantityAlert(for: .recycleCan)
    }

    @IBAction func glassTapped(_ sender: UIButton) {
        showQuantityAlert(for: .recycleGlass)
    }

    @IBAction func paperTapped(_ sender: UIButton) {
        showQuantityAlert(for: .recyclePaper)
    }
    
    @IBAction func ttt(_ sender: UIButton) {
        // 싱글톤 인스턴스에 리셋 호출
        CarbonStorage.shared.resetAll()
    }
    
    private func setupLottie() {
        lottie.animation = Animation.named("recycle")
        lottie.backgroundColor = .clear
        lottie.isOpaque = false
        lottie.loopMode  = .loop
        lottie.play()
    }

    // MARK: - Alert / Navigation
    private func showQuantityAlert(for source: CarbonSource) {
        let alert = UIAlertController(
            title: "\(source.displayName)... 몇 개 배출했나요?",
            message: nil,
            preferredStyle: .alert
        )

        alert.addTextField { tf in
            tf.keyboardType = .numberPad
            tf.text = "1"
            tf.textAlignment = .center
            tf.font = .systemFont(ofSize: 32)
        }

        alert.addAction(.init(title: "취소", style: .cancel))
        alert.addAction(.init(title: "확인", style: .default) { _ in
            let text = alert.textFields?.first?.text ?? ""
            let qty = Int(text) ?? 1
            let totalCarbon = source.calculateCarbon(amount: qty)
            
            if let rewardVC = self.storyboard?
                .instantiateViewController(withIdentifier: "RewardVC") as? RewardViewController {
                rewardVC.carbonAmount = totalCarbon
                rewardVC.source      = source
                self.navigationController?.pushViewController(rewardVC, animated: true)
            }
        })

        present(alert, animated: true)
    }
}

