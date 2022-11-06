# README

# 기본구조

## MVVM

- MVVM 패턴
- UIViewController에서 작성할 수 있는 UITableView, UIButton 등 UI컴포넌트 관련 로직을 최대한 타 클래스로 이관
- 모델, 뷰모델, 뷰 간에 일어날 수 있는 데이터의 흐름, 사용자 입력 이벤트의 전달은 클로저를 통해 처리
    
    ### Model
    
    - 비즈니스 로직
    - Repostiory를 통해 DataBase 관련 클래스와 상호작용
    - ViewModel의 초기화, ViewModel과의 참조 관계 설정
    - 초기화 시 Repository를 주입 받음
    
    ### ViewModel
    
    - Model이 처리하기에 작은, View의 특성과 연관된 로직 처리
    - Model에서 받은 데이터의 가공
    - View에 필요한 데이터 전달
    - View의 이벤트 수신. 필요시 Model로 전파
    - 초기화 시 Repository를 주입 받지 않음
    
    ### View
    
    - UITableView, UIButton등 UI컴포넌트를 add한 뷰
    - UITableViewDelegate, DataSource 역할을 겸함
    - UIButton Action 등 사용자 입력 이벤트를 수신
    - 사용자 입력 이벤트, 입력값 등 별도 처리가 필요한 사항은 ViewModel로 전달
    - 필요시 2개 이상의 View를 ViewController에 addSubView할 수 있음
    - 초기화 시 ViewModel을 주입 받음

## Repository

- Model 클래스 생성 시 기본적으로 주입하는 클래스
- HTTPClient와의 참조 관계
- UnitTest 추가 시 MockRepository의 구현을 용이하게 하고자 RepositoryProtocol을 채택
- ViewModel은 생성 시 Repository를 주입받지 않음. ViewModel은 연계된 특정한 View에 특화된 로직처리, 사용자의 입력 이벤트 송수신과 같은 처리만을 진행함. ViewModel이 Repository를 주입받지 않는 것은 ViewModel이 Repository와 타이트하게 커플링 되는 것을 막고자 하는 의도도 있음.

## HTTPClient

- API호출 관련 사항 처리

## ViewController Presentation + Dependency Injection

- ViewController에서 의존성주입, 다음 ViewController의 생성, Present 등 여러 코드를 작성하는 방법을 지양하고자 구현
- 이를 위해 Scenable, SceneBuildable, Routable, SceneCategory, SceneContext등 기본적인 프로토콜, Enum, Class를 구성
- Model 클래스는 연관된 ViewModel 클래스로부터 클로저로 처리된 특정한 알림을 받으며, 어느 ViewController를 띄울지, 어느 Alert을 띄울지와 같은 것을 평가하는 로직을 수행함. 수행된 로직에 따라 띄울 ViewController를 정하고 Model과 연결된 ViewController는 route() 메소드를 호출함. route() 메소드가 호출된 다음의 로직은 Routable, SceneBuildable이 처리함
    
    ### Routable, SceneBuildable, Scenable
    
    - SceneDelegate, ViewController는 각 클래스만을 위한 별도의 프로토콜을 채택할 수 있으며 이 별도의 프로토콜이란 SceneBuildable, Routable을 채택한 별도의 aaaSceneBuildable, aaaRoutable을 의미함
    - 필요시 aaaSceneBuildable, aaaRoutable 등의 프로토콜 조합, 프로토콜 제약을 활용
    - Routable, SceneBuildable은 파라미티로 SceneCategory Enum 값을 받으며 이 값을 통해 다음에 어느 ViewController를 생성하고, Present 할 지를 분기 처리함
    - 상기 로직을 처리하고자 모든 ViewController는 Scenable 프로토콜을 따름
    
    ### SceneCategory
    
    - App에서 전반적으로 present, push 되어야 할 ViewController에 대한 열거형
    - 각 case는 연관값으로 SceneCategory안에 정의된 또다른 ViewController에 대한 enum을 받거나, 의존성 주입을 위해 만든 클래스인 SceneContext를 받을 수 있음
    
    ### SceneContext
    
    - 각 ViewController에 주입해야 할 Model을 들고 있는 클래스

---

# UI Drawing

- UI 속성 추가를 위해 별도의 프로토콜 추가
    
    ## Programmatic UI
    
    - 스토리보드 - xib 미사용, 오토레이아웃으로 컨스트레인트 설정
    - UIViewController와 같은 클래스에는 별도의 UI컴포넌트를 붙이지 않음. 대신 UIView를 필요에 따라 2, 3개 이상 생성 후 addSubView를 진행.
    - addSubView된 UIView가 UITableView, UIButton 등의 UI컴포넌트를 소유
    - addSubView된 UIView가 UITableViewDelegate, DataSource의 역할을 수행
    
    ## UI Attribute - Presentable
    
    - 뷰간 하이어라키 설정, 오토레이아웃 설정, 바인딩 설정 등 기본적인 사항 진행 시 모든 ViewController, View가 어느 정도는 정해진 순서대로 절차를 진행해야 코드 가독성이 높아질 것으로 판단하여 만든 프로토콜
    - 강한 제약사항을 위한 것은 아니나 추후 다른 프로토콜과 합성, 제약 추가를 통해 응용이 가능할 것이기에 추가
    
    ## UI Attribute - Styleable
    
    - UI의 폰트컬러, 텍스트정렬, 그림자 효과 등을 추가할 시 한줄 한줄 적는 방식을 지양하고자 추가
    - 여러 속성을 한 번에 줄 수 있는 클로저를 넘기고, 실행하는 방식으로 구현
    - UIView, UIBarButtonItem, UINavigationItem 등 UI컴포넌트는 Styleable 프로토콜을 채택, 해당 UI타입들은 Styleable 의 메소드를 호출할 수 있음

---

# Concurrency

- async, await, task, taskGroup 이용한 처리

---

# 기능

![데이터 삭제](README%20ca936a7d28d54f1fb7ce068ad4273dc5/2_MP4_AdobeExpress.gif)

데이터 삭제

![컴포지셔널 레이아웃 변경](README%20ca936a7d28d54f1fb7ce068ad4273dc5/3_MP4_AdobeExpress.gif)

컴포지셔널 레이아웃 변경

![프로필이미지 확대 축소](README%20ca936a7d28d54f1fb7ce068ad4273dc5/4_MP4_AdobeExpress.gif)

프로필이미지 확대 축소

---