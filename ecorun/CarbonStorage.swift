import Foundation

class CarbonStorage {
    static let shared = CarbonStorage()
    private let defaults = UserDefaults.standard

    private let keyTotalCarbon  = "total_carbon"
    private let keyPrevStage    = "prev_stage"
    private let keyTotalPoint   = "total_point"

    /// 오늘 날짜 기반 키
    private func todayKey() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        return "carbon_today_\(fmt.string(from: Date()))"
    }

    // MARK: - 조회

    func totalCarbon() -> Int {
        defaults.integer(forKey: keyTotalCarbon)
    }

    func todayCarbon() -> Int {
        defaults.integer(forKey: todayKey())
    }

    func totalPoint() -> Int {
        defaults.integer(forKey: keyTotalPoint)
    }

    // 새싹 단계 계산
    func stage(for total: Int) -> Int {
        switch total {
        case let t where t >= 1000: return 5
        case let t where t >= 800:  return 4
        case let t where t >= 400:  return 3
        case let t where t >= 200:  return 2
        default:                     return 1
        }
    }

    // MARK: - 저장

    /// 포인트 추가
    func addPoint(amount: Int) {
        let current = totalPoint()
        defaults.set(current + amount, forKey: keyTotalPoint)
    }

    /// 탄소 절감량 추가
    func addCarbon(amount: Int) {
        let currentTotal = totalCarbon()
        let todayTotal   = todayCarbon()

        // 이전 단계는 currentTotal 기준
        let prevStage = stage(for: currentTotal)

        let newTotal      = currentTotal + amount
        let newTodayTotal = todayTotal + amount

        // 저장
        defaults.set(newTotal, forKey: keyTotalCarbon)
        defaults.set(newTodayTotal, forKey: todayKey())
        // Android는 prevStage를 그대로 putInt(KEY_PREV_STAGE)
        defaults.set(prevStage, forKey: keyPrevStage)
    }

    /// 초기화
    func resetAll() {
        if let bundle = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundle)
            defaults.synchronize()
        }
    }
}
