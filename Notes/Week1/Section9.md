- SwiftUI 기본 세팅(Proj Name : HelloSwiftUI)
    - App 파일과 View 파일로 구성

## App 파일
```swift
import SwiftUI
// main entry point
@main
struct HelloSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // get rendered on the screens
        }
    }
}
```

- App 프로토콜을 채택
    - App? 앱의 구조와 동작을 나타내는 타입.
- main annotation 명시 : 한개의 앱에 1개의 main annotation만 존재해야한다.
    - app의 entry point를 명시함
- body라는 computed property를 이용해 app의 content를 표시
    - body는 Scene protocol 준수
    - Scene은 view 계층에서 가장 root에 해당되며 시스템에 의해 life cycle을 가지고 있는 형태임. scene type에서만 windowGroup, Settings를 사용
- WindowGroup?
    - Window라는 개념은 뷰들의 컨테이너 역할을 하면서 동시에 터치 이벤트와 같은 이벤트를 가장 먼저 수신하여 subview들에게 이벤트를 전달하는(responder chain) 기능
    - macOS와 iPadOS와 같이 그룹으로부터 여러개의 window를 띄울 수 있는 형태일때 WindowGroup을 여러개 정의하여 사용

## View 파일

```swift
//
//  ContentView.swift
//  HelloSwiftUI
import SwiftUI

// not class. have to make struct
struct ContentView: View { // View protocol
    var body: some View {
        // body property - tell what needs to be displayed on the screen
        // anything return
        // 이 경우는 Text View return
        VStack(spacing: 20) { // Vertical stack
            Text("Hello World. I am doyeon kim.")
                .foregroundStyle(.cyan)
                .font(.title2)
            Text("Second Line")
                .foregroundStyle(.green)
            Text("Second Line")
            HStack {
                Text("Left")
                Text("Right")
                    .fontWeight(.heavy)
            }
        }.foregroundColor(.orange) // style define 안되어있는 요소에게만 적용
        // 가장 가까운 modifier가 적용됨? -> yes
        // 그래서 modifier 적용할 때는
        // View Protocol 공용 modifier 넣기 전에
        // 각 View의 수식어를 먼저 넣어줘야 원하는 대로 나옴
    }
}

// Preview macro
#Preview {
    ContentView()
}
```

View 코드 적용 결과

세로 스택에 텍스트 3개와 가로 스택 들어있는 구조

→ 내부의 가로 스택에 텍스트 2개가 들어있음

---

### View struct?

UIKit에서는 View가 Class였지만, SwiftUI에서는 Struct다. Struct는 value-type이어서 multi-threading 환경에서 강한 순환 참조 문제가 발생하지 않고, 더 적은 메모리를 사용한다.

- 추가 설명
    
    참조reference-type인 class는 compile level에서 언제 메모리에 할당or해제되는지 알 수가 없고 그 과정에서 참조계산을 해야하고, process에서 heap은 공유되는 영역이기 때문에 thread safety하지 않음
    

하지만 Struct는 상속이 불가능하다. 그래서 SwiftUI의 View는 View Protocol을 채택한다.

[SwiftUI / View](https://velog.io/@minsang/SwiftUI-View)

---

### Body

View protocol을 채택하면, 반드시 computed property인 body 변수를 정의해야한다. View를 화면에 그릴 때, body property를 읽어서 표시한다. 사용자 입력이 변하거나 시스템 이벤트가 발생할 때마다 반복적으로 읽고 뷰를 그린다.

View protocol은 UI components를 return.

body property에 대한 associated type을 나타내야하는데, some View 구문을 사용하여 불명확한 유형으로 선언한다. content에 따라 정확한 유형이 바뀌고 자동으로 유추함.

![스크린샷 2024-09-21 오후 8.19.58.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/8c944a44-a786-489e-91b1-902da81aa426/5b5eafcb-94de-4c76-9097-97a49842bd08/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-09-21_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.19.58.png)

### Stack

## Image 다루기

```swift
//
//  ContentView.swift
//  HelloSwiftUI
// 
// Credits for the image
// Give a shoutout to Zdeněk Macháček on social or copy the text below to attribute.
// https://unsplash.com/@zmachacek

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // 이미지뷰 추가
            Image("costa-rica")
                .resizable()
                .aspectRatio(contentMode: .fit) // fit it proportionally
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                // shape of image
            
            // download할 필요 없이 이미지 적용
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1552727131-5fc6af16796d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3898&q=80")!) { image in
                image.resizable()
            } placeholder: {
                ProgressView("Downloading...")   
            }

            Text("First Line")
                .foregroundStyle(.cyan)
                .font(.title3)
                .padding([.top, .bottom], 20) // 패딩 넣을 부분 지정 가능. 패딩 수치 지정
            
            Text("Second Line")
                .foregroundStyle(.green)
            Text("Third Line")
            HStack {
                Text("Left")
                Text("Right")
                    .fontWeight(.heavy)
            }
        }.foregroundStyle(.orange)
            .padding() // put the spacing from the outside.
    }
}

#Preview {
    ContentView()
}

```

### Image

### AsyncImage

![스크린샷 2024-09-21 오후 8.56.07.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/8c944a44-a786-489e-91b1-902da81aa426/45e4af4e-f281-450f-aeac-7ec7efa83fcb/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-09-21_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.56.07.png)
