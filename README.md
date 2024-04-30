# Authlabs_EEILS
AI활용 iOS 앱 개발자 부트캠프 채용형 미니인턴 - 오스랩스
## 📖 목차
- [🛠️ 기술스택](#-기술스택)
- [🚀 트러블 슈팅](#-트러블-슈팅)
- [📱 주요기능과 스크린샷](#-주요기능과-스크린샷)
- [💻 개발 도구 및 활용한 기술](#-개발-도구-및-활용한-기술)
---

![image](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/4679b732-a68e-40ff-b14a-c5b120a070d9)

---

## 🛠️ 기술스택
<p align="leading">
  <img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white"/>
  <img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=uikit&logoColor=white"/>
</p>

---

## 🚀 트러블 슈팅
- **SceneKit을 사용하여 3D 객체의 bounding box를 화면 좌표로 변환**
  - ARKit을 활용하면서 트래킹된 이미지를 캡처할 때, 3D 좌표를 평면좌표로 계산하여 해당 이미지를 가져오는 방법에 대한 이슈가 있었습니다.
  - 따라서, UIScreen의 main 스크린의 스케일을 가져와서 scale 상수에 저장 후 이 값을 통해 화면의 픽셀에 따라 변화할 수 있게 했습니다.
  - node 객체의 bounding box의 최소점과 최대점을 min과 max 변수에 저장합니다. bounding box는 3D 객체를 감싸는 가상의 사각형 영역을 나타냅니다.
  - 최소점과 최대점을 SCNVector3 객체로 변환하여 각각 minVector와 maxVector에 저장합니다. 이 벡터는 3D 공간에서의 해당 점을 나타냅니다.
  - node 객체의 로컬 좌표계에서 최소점과 최대점의 위치를 화면 좌표계로 변환합니다. projectPoint 메서드를 사용하여 3D 좌표를 2D 화면 좌표로 변환합니다.
  - 최소점의 화면 좌표를 가져와서 scale 값과 곱하여 디스플레이에 대한 픽셀 밀도를 고려한 좌표로 변환합니다.
  - 최소점과 최대점의 x 및 y 좌표의 차이를 계산하여 너비와 높이를 구합니다. 이 값을 화면의 픽셀 밀도로 고려하여 변환합니다.
  - 위에서 계산한 좌표와 크기를 사용하여 CGRect를 생성하고 반환합니다. 이렇게 함으로써 3D 객체의 bounding box가 화면에서 어떤 위치에 있는지와 크기가 얼마나 되는지를 나타내는 CGRect를 얻을 수 있습니다.
    ```swift
    private func resizeTrackingImage(of node: SCNNode) -> CGRect {
    let scale = UIScreen.main.scale
    let (min, max) = node.boundingBox
    
    let minVector = SCNVector3(
      min.x,
      min.y,
      min.z
    )
    let maxVector = SCNVector3(
      max.x,
      max.y,
      max.z
    )
    
    let minScreenPoint = self.projectPoint(node.convertPosition(minVector, to: nil))
    let maxScreenPoint = self.projectPoint(node.convertPosition(maxVector, to: nil))
    
    let x = CGFloat(minScreenPoint.x) * scale
    let y = CGFloat(minScreenPoint.y) * scale
    let width = CGFloat(maxScreenPoint.x - minScreenPoint.x) * scale
    let height = CGFloat(maxScreenPoint.y - minScreenPoint.y) * scale
    
    return CGRect(
      x: x,
      y: y,
      width: width,
      height: height
      )
    }
    ```

---

## 📱 주요기능과 스크린샷

|로딩뷰|마커등록 뷰(1)|마커등록 뷰(2)|마커등록 뷰(3)|
|:-----------:|:--------:|:----------:|:---------:|
|![IMG_7141](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/184f827c-fc3c-4d52-9da5-2134a5f7b9e2)|![IMG_7133](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/4e397de5-c182-46ed-8043-8ea3387fe5af)|![IMG_7135](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/7007d81d-33bf-4a5e-8e64-45d52676e74d)|![IMG_7130](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/a0c25213-6f18-423a-a40c-e4909ba57bb4)|

|카메라뷰|분석 로딩|분석결과|저장목록|
|:-----------:|:--------:|:----------:|:---------:|
|![IMG_93EBA69D0AF3-1](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/555a8ec6-746a-4460-bc14-a14dbbf4a402)|![IMG_7136](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/69ce0cf7-adbb-462c-baa4-f00b82f49396)|![IMG_C512294FF03E-1](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/4d025002-f495-4813-8131-80b5f0fa2f9d)|![IMG_7134](https://github.com/Changhyun-Kyle/Authlabs_EEILS/assets/101093592/4b0726c8-8293-4986-bb0d-108693ce25a7)|

---

## 💻 개발 도구 및 활용한 기술
- 개발 언어 : Swift
- 개발 환경 : Swift5 16.2 ~, SE ~ iPhone 14 Pro 호환, 가로모드, 라이트모드 미지원
- 활용한 기술
    - Xcode
    - ARKit
    - openAI(Vision API)
---
