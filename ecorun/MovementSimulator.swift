//
//  MovementSimulator.swift
//  ecorun
//
//  Created by mac on 2025/06/18.
//
import CoreLocation

/// 1) 모드 정의
public enum MovementMode {
    case walk, run, bike

    /// 모드별 한 스텝(버튼 누름)당 이동 거리(m)
    var stepDistance: CLLocationDistance {
        switch self {
        case .walk: return 1
        case .run:  return 2
        case .bike: return 4
        }
    }
}

/// 2) 시뮬레이터 클래스
public class MovementSimulator {
    /// 현재 위치
    private(set) var coordinate: CLLocationCoordinate2D

    /// 현재 모드 (외부에서 바꿀 수 있음)
    public var mode: MovementMode = .walk

    public init(startAt coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.5823639, longitude: 127.0104167)) {
        self.coordinate = coord
    }

    /// 북쪽(bearing 0°)으로 한 스텝 이동 후 새 좌표 반환
    @discardableResult
    public func step(bearing: CLLocationDirection = 0) -> CLLocationCoordinate2D {
        let earthRadius = 6_371_000.0
        let distRad    = mode.stepDistance / earthRadius
        let bearRad    = bearing * .pi / 180

        let lat1 = coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180

        let lat2 = asin(sin(lat1) * cos(distRad)
                      + cos(lat1) * sin(distRad) * cos(bearRad))
        let lon2 = lon1 + atan2(sin(bearRad) * sin(distRad) * cos(lat1),
                                cos(distRad) - sin(lat1) * sin(lat2))

        let newLat = lat2 * 180 / .pi
        let newLon = lon2 * 180 / .pi
        coordinate = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        return coordinate
    }
}
