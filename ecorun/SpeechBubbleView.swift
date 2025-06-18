//
//  SpeechBubbleView.swift
//  ecorun
//
//  Created by mac on 2025/06/18.
//
import UIKit

/// 말풍선 뷰
class SpeechBubbleView: UIView {
    private let label = UILabel()

    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = .clear

        label.text = text
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        addSubview(label)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이블 패딩
        let inset: CGFloat = 8
        label.frame = bounds.insetBy(dx: inset, dy: inset)
    }

    override func draw(_ rect: CGRect) {
        // 말풍선 배경
        let path = UIBezierPath()
        let radius: CGFloat = 12
        let pointerSize: CGFloat = 8
        // 둥근 사각형
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width - radius, y: radius),
                    radius: radius, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius - pointerSize))
        path.addArc(withCenter: CGPoint(x: rect.width - radius, y: rect.height - radius - pointerSize),
                    radius: radius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        // 포인터
        path.addLine(to: CGPoint(x: rect.midX + pointerSize, y: rect.height - pointerSize))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        path.addLine(to: CGPoint(x: rect.midX - pointerSize, y: rect.height - pointerSize))
        // 왼쪽 하단
        path.addLine(to: CGPoint(x: radius, y: rect.height - pointerSize))
        path.addArc(withCenter: CGPoint(x: radius, y: rect.height - radius - pointerSize),
                    radius: radius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(withCenter: CGPoint(x: radius, y: radius),
                    radius: radius, startAngle: .pi, endAngle: -CGFloat.pi/2, clockwise: true)
        path.close()

        UIColor.black.withAlphaComponent(0.7).setFill()
        path.fill()
    }
}
