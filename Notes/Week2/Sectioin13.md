# Getting Started

Tags: MVPattern
Date: October 4, 2024
Number: 6

# Understanding MVVM Pattern

MVVM : Model View ViewModel

- Model : Business object or domain object → Brainv
    - example. Order(email, name, price, quantity properties & updateOrder, updateQuantity, addDiscount methods)
- View : Represents the UI for the application
- View Model : Takes the data from the model and provides it to the view

example. OrderListScreen(view) ↔ OrderListViewModel ↔ Order(model)

networking example. orderlistScreen → orderListViewModel → HTTPClient → Server 이러면, Server → (DTO) → HTTPClient → OrderListViewModel → order list on screen(update)

# MVVM in WPF vs SwiftUI

WPF : 다른 파일에서 vm 관리. binding

SwiftUI : 한 파일(view)에서 vm 선언 후 바로 binding → 따로 ObservableObject 만드는거 비효율적임

# Limitations of MVVM in SwiftUI

모든 스크린마다 vm을 만드는 것 → no → How? Presentation Model!

UseCase 1. View is the ViewModel. 따로 뷰모델 파일을 두지 않음.

UseCase 2. View ↔ Aggregate Model ↔ HTTPClient ↔ Server 구조로 설계하기. Aggregate Root Model을 한 개만 둬서 여러 스크린을 관리(모듈화)

Active Record Pattern : SwiftData, CoreData model

### Resources

[How to pass EnvironmentObject to a View Model](https://stackoverflow.com/questions/59491675/swiftui-how-to-pass-environmentobject-into-view-model)

[Core Data MVVM in SwiftUI NSFetchedResultsController](https://youtu.be/gGM_Qn3CUfQ)

[Is MVVM Right for SwiftUI?](https://www.raywenderlich.com/35112528-is-mvvm-right-for-swiftui-live-seminar-coming-soon)

[Implementing Generic Network Layer in Swift](https://youtu.be/URtjMI3Y1Dw)

[MV State Pattern - A Better Way of Building SwiftUI Apps](https://azamsharp.com/2022/08/09/intro-to-mv-state-pattern.html)

[SwiftUI View is also a View Model](https://azamsharp.com/2022/07/21/view-is-the-view-model.html)