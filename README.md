# 🌱 ecorun

사용자의 탄소 절감을 돕기 위해 **걷기, 달리기, 자전거**와 **분리 배출** 기능을 제공하는 iOS 앱이에요  
IOS 정책상 실제 GPS 대신 시뮬레이션을 통해 환경 제약 없이  
쉽고 재미있게 운동 기록 및 분리 배출 관리를 경험을 통해 새싹을 키울 수 있어요

## 🚀 주요 기능
| 기능               | 설명                                               |
| ---------------- | ------------------------------------------------ |
| **운동 활동**     | 걷기, 달리기, 자전거 모드를 선택하여 이동 거리를 시뮬레이션 해요           |
| **분리 배출**        | 플라스틱, 캔, 유리, 종이 1개당 절감 탄소량을 실시간으로 계산해요              |
| **탄소 절감 기록**     | 절감량과 재활용 횟수를 `CarbonStorage`에 저장, ‘새싹 단계’ 레벨을 제공해요 |
| **리워드 화면**       | 목표 달성 시 리워드 화면으로 이동, 절감량 확인이 가능해요                      |
| **맵 제어**         | `MKMapView` 사용, 한성대 위치 기반으로 확대, 축소, 내 위치 이동 버튼을 지원해요   |
| **Lottie 애니메이션** | 로티 애니메이션 재생으로 귀엽고 시각적인 재미를 제공해요                       |

---
## 📸 스크린샷
<p align="center">
  <img src="https://github.com/user-attachments/assets/ffefc3d1-8feb-406d-9d8a-10ae8c4753c8" width="200"/>
  <img src="https://github.com/user-attachments/assets/14bb87ad-9024-4d9a-b1cb-33b9d1c275e1" width="200"/>
  <img src="https://github.com/user-attachments/assets/c241f634-985d-45b3-b4ab-69c63a042466" width="200"/>
  <img src="https://github.com/user-attachments/assets/14fc7b10-861a-46e8-ace3-5a1c0e61980f" width="200"/><br/>
  <img src="https://github.com/user-attachments/assets/bc6ea62f-4e35-4666-ae7a-732471190f29" width="200"/>
  <img src="https://github.com/user-attachments/assets/dcc73f45-0b98-4abc-98cc-b12082187750" width="200"/>
  <img src="https://github.com/user-attachments/assets/b1080de8-ee62-4dd5-bef9-4fdb602120f2" width="200"/>
  <img src="https://github.com/user-attachments/assets/ab37db1c-f403-41e2-b8e5-9033f3a2b2ff" width="200"/>
</p>

## 🗂 프로젝트 구조

```text
ecorun/
├── AppDelegate.swift
├── SceneDelegate.swift
├── CarbonSource.swift          # 탄소 관련 로직 저장
├── CarbonStorage.swift         # 절감량, 포인트, 단계 저장 로직 (DB, 클라우드로 확장 가능)
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
