import Foundation

/// 운동 vs 재활용 구분 타입
enum CarbonType {
    case exercise
    case recycle
}

/// 탄소 절감 소스 항목
enum CarbonSource {
    // 운동 (100m당 절감량)
    case walk
    case run
    case bike
    
    // 재활용 (개수당 절감량)
    case recyclePet
    case recycleCan
    case recycleGlass
    case recyclePaper

    /// 표시 이름
    var displayName: String {
        switch self {
        case .walk:          return "걷기"
        case .run:           return "달리기"
        case .bike:          return "자전거"
        case .recyclePet:    return "플라스틱"
        case .recycleCan:    return "캔"
        case .recycleGlass:  return "유리"
        case .recyclePaper:  return "종이"
        }
    }

    /// 소스 타입
    var type: CarbonType {
        switch self {
        case .recyclePet, .recycleCan, .recycleGlass, .recyclePaper:
            return .recycle
        default:
            return .exercise
        }
    }

    /// 100m당 절감량 (운동 전용)
    var gramsPer100m: Int {
        switch self {
        case .walk: return 20
        case .run:  return 25
        case .bike: return 15
        default:    return 0
        }
    }

    /// 개수당 절감량 (재활용 전용)
    var gramsPerUnit: Int {
        switch self {
        case .recyclePet:    return 30
        case .recycleCan:    return 50
        case .recycleGlass:  return 10
        case .recyclePaper:  return 2
        default:             return 0
        }
    }

    /**
     # 탄소 절감량 계산
     - 운동: 이동 거리(m)를 입력, 100m당 지정량 계산
     - 재활용: 개수를 입력, 개수당 지정량 계산
     */
    func calculateCarbon(amount: Int) -> Int {
        switch type {
        case .recycle:
            return gramsPerUnit * amount
        case .exercise:
            return (amount / 100) * gramsPer100m
        }
    }
}
