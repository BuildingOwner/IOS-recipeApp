# RecipeApp

## 소개

**RecipeApp**은 iOS 플랫폼을 위한 레시피 애플리케이션입니다. 사용자가 다양한 요리법을 검색, 즐겨찾기, 그리고 상세 정보를 확인할 수 있도록 설계되었습니다. Swift 언어와 Firebase를 활용하여 구현되었으며, 직관적인 UI와 간단한 기능 흐름을 제공합니다.

---

## 주요 기능

- **레시피 검색**: 사용자가 원하는 레시피를 키워드로 검색할 수 있습니다.
- **즐겨찾기 관리**: 관심 있는 레시피를 즐겨찾기에 추가하고 관리할 수 있습니다.
- **레시피 상세 정보 확인**: 선택한 레시피의 세부 정보를 표시합니다.
- **Firebase 연동**: Firebase를 통해 데이터 관리 및 사용자 경험을 향상시킵니다.
- **토스트 메시지 지원**: 사용자 피드백을 위한 간단한 알림 메시지 제공.

---

## 파일 구조

| 파일명 | 설명 |
| :-- | :-- |
| `AppDelegate.swift` | 앱의 라이프사이클 및 초기 설정 관리 |
| `RecipeAppApp.swift` | SwiftUI 앱 엔트리 포인트 |
| `MainView.swift` | 메인 화면 UI 및 로직 |
| `SearchView.swift` | 레시피 검색 화면 UI 및 로직 |
| `SearchRecipeView.swift` | 검색 결과를 표시하는 뷰 |
| `RecipeDetailView.swift` | 레시피 상세 정보를 보여주는 화면 |
| `BookmarkView.swift` | 즐겨찾기 관리 화면 |
| `FirebaseService.swift` | Firebase 연동을 위한 서비스 클래스 |
| `BundleKeyLoad.swift` | 번들 키 로드 관련 유틸리티 |
| `Toast.swift` | 사용자 피드백용 토스트 메시지 구현 |
| `Assets.xcassets` | 애플리케이션에서 사용하는 이미지 및 리소스 관리 |

---

## 기술 스택

- **언어**: Swift
- **프레임워크**: SwiftUI
- **백엔드 서비스**: Firebase