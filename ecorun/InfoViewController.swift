//
//  InfoViewController.swift
//  ecorun
//
//  Created by mac on 2025/06/16.
//
import UIKit

class InfoViewController: UIViewController {
    // MARK: – IBOutlets
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvLevelGuide: UILabel!
    @IBOutlet weak var tvMyLevel: UILabel!
    @IBOutlet weak var progressCarbon: UIProgressView!
    @IBOutlet weak var stageProgressLabel: UILabel!
    @IBOutlet weak var tvTotalCarbon: UILabel!
    @IBOutlet weak var tvTip: UILabel!

    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "내 정보"

        // Galmuri11-Bold 폰트
        let titleFont = UIFont(name: "Galmuri11-Bold", size: 32)!
        let guideFont = UIFont(name: "Galmuri11-Bold", size: 20)!
        let tipFont   = UIFont(name: "Galmuri11-Bold", size: 16)!

        tvTitle.attributedText = NSAttributedString(
            string: "🌿 새싹 성장 단계",
            attributes: [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
        )

        tvLevelGuide.attributedText = NSAttributedString(
            string: """
    🌱 새싹 단계 기준

    1단계: 0 ~ 199g
    2단계: 200 ~ 399g
    3단계: 400 ~ 799g
    4단계: 800 ~ 999g
    5단계: 1000g 이상

    추후 추가될 예정이에요..
    """,
            attributes: [
                .font: guideFont,
                .foregroundColor: UIColor.darkGray
            ]
        )
        
        let total = CarbonStorage.shared.totalCarbon()
        stageProgressLabel.text = "나의 성장은... \(total)/1000"

        tvTip.attributedText = NSAttributedString(
            string: """
    🌏 지구를 위한 한 걸음
    🏃 달릴수록 탄소는 줄고 건강은 늘어요
    🚲 자전거는 가장 친환경적인 이동 수단이에요
    ♻️ 분리배출 하나가 지구의 숨통을 틔워요
    🔥 작은 실천이 기후 위기를 막을 수 있어요
    💧 맑은 공기와 푸른 지구를 만들어가요

    ©2025 IOS 프로그래밍
    """,
            attributes: [
                .font: tipFont,
                .foregroundColor: UIColor.black
            ]
        )

        // 프로그레스바 스타일
        progressCarbon.trackTintColor = .systemGray5
        progressCarbon.progressTintColor = .systemGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func updateUI() {
        let total = CarbonStorage.shared.totalCarbon()
        let stage = CarbonStorage.shared.stage(for: total)

        let myLevelFont = UIFont(name: "Galmuri11-Bold", size: 20)!
        let totalCarbonFont = UIFont(name: "Galmuri11-Bold", size: 18)!

        tvMyLevel.attributedText = NSAttributedString(
            string: "내 새싹 단계 🌱 : \(stage) 단계",
            attributes: [
                .font: myLevelFont,
                .foregroundColor: UIColor.black
            ]
        )

        tvTotalCarbon.attributedText = NSAttributedString(
            string: "누적 탄소 절감량: \(total)g",
            attributes: [
                .font: totalCarbonFont,
                .foregroundColor: UIColor.black
            ]
        )

        let progress = Float(min(total, 1000)) / 1000.0
        progressCarbon.setProgress(progress, animated: true)
    }
}
