# 🌱 ecorun

`ecorun`는 사용자의 탄소 절감을 돕기 위해 **걷기·달리기·자전거 모드**와 **분리 배출** 기능을 제공하는 iOS 앱으로
IOS 정책상 실제 GPS 대신 시뮬레이션을 통해 환경 제약 없이 쉽고 재미있게 운동 기록 및 분리 배출 관리를 경험할 수 있습니다

## 🚀 주요 기능

| 기능               | 설명                                               |
| ---------------- | ------------------------------------------------ |
| **운동 활동**     | 걷기·달리기·자전거 모드를 선택하여 이동 거리 시뮬레이션            |
| **분리 배출**        | 플라스틱·캔·유리·종이 1개당 절감 탄소량 실시간 계산 및 표시              |
| **탄소 절감 기록**     | 절감량과 재활용 횟수를 `CarbonStorage`에 저장, ‘새싹 단계’ 레벨링 제공 |
| **리워드 화면**       | 목표 달성 시 리워드 화면으로 이동, 절감량 확인                      |
| **맵 제어**         | `MKMapView` 사용, 한성대 위치 기반으로 줌 인, 줌 아웃, 내 위치 이동 버튼 지원   |
| **Lottie 애니메이션** | 모드별 애니메이션 재생으로 시각적인 재미 제공                        |

---

## 📸 스크린샷

<!-- 스크린샷 이미지를 추가하세요 -->

---

## 🗂 프로젝트 구조

```text
ecorun/
├── AppDelegate.swift
├── SceneDelegate.swift
├── CarbonSource.swift          # 분리 배출 탄소 계산 공식
├── CarbonStorage.swift         # 절감량·포인트·단계 저장 로직
├── MovementSimulator.swift     # 운동 시뮬레이션 클래스
├── WalkViewController.swift    # 걷기 모드 화면
├── RunViewController.swift     # 달리기 모드 화면
├── BikeViewController.swift    # 자전거 모드 화면
├── RecycleViewController.swift # 분리 배출 화면
├── RewardViewController.swift  # 리워드 화면
├── Main.storyboard
├── Assets.xcassets
├── InfoViewController.swift    # 앱 정보 화면
├── MyCustomFonts.swift         # 커스텀 폰트 등록
└── Fonts/Galmuri11-Bold.ttf
```
