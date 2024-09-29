## State

### Int 변수 예시

- Struct는 변경되는 property를 가질 수 없어서 따로 명시해줌
- 버튼을 클릭하면 count의 값이 1씩 증가하므로 count의 값이 변경될 수 있도록 State

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            Text("Hello World!")
            Text("\(count)")
                .font(.largeTitle)
            Button("Increment") {
                count += 1
            }
        }
    }
}
```

### Bool 변수 예시

```swift
import SwiftUI

struct ContentView: View {
    
    @State private var isOn: Bool = false
     
    var body: some View {
        VStack {
            Toggle(isOn: $isOn, label: {
                Text(isOn ? "ON": "OFF")
                    .foregroundStyle(.white)
            }).fixedSize()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isOn ? .yellow: .black)
    }
}
```

## TextField

```swift
struct ContentView: View {
     
    @State private var name : String = ""
    @State private var friends: [String] = []
    
    var body: some View {
        VStack {
            TextField("Enter name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    friends.append(name)
                    name = ""
                }
            List(friends, id: \.self) { friend in
                Text(friend)
            }
            Spacer()
        }.padding()
    }
}
```

- **`@State private var name: String = ""`**
    - `name`은 `TextField`에 입력된 텍스트를 저장하는 상태 변수임. 초기 값은 빈 문자열로 설정돼 있음.
- **`@State private var friends: [String] = []`**
    - `friends`는 입력된 이름을 저장하는 배열임. 초기 값은 빈 배열임.
- **`TextField("Enter name", text: $name)`**
    - `TextField`는 사용자가 텍스트를 입력할 수 있는 필드임. `"Enter name"`은 placeholder로 표시되고, 사용자가 입력한 값은 `$name`을 통해 바인딩됨.
- **`.onSubmit { ... }`**
    - 사용자가 키보드에서 리턴(return) 키를 눌렀을 때 호출됨. 여기선 입력한 `name`을 `friends` 배열에 추가하고, `name`을 다시 빈 문자열로 초기화함.
- **`List(friends, id: \.self)`**
    - `List`는 배열 `friends`를 화면에 표시함. `id: \.self`는 각 항목이 고유하게 구분될 수 있도록 배열의 값을 ID로 사용함.
- **`Spacer()`**
    - 화면에서 빈 공간을 추가해 아래쪽에 여유를 줌.
- **`.padding()`**
    - 뷰의 모든 가장자리에 여백을 줌.

## List

```swift
import SwiftUI

struct ContentView: View {
     
    @State private var search: String = ""
    @State private var friends: [String] = ["John", "Mary", "Steven", "Steve", "Jerry"]
    
    @State private var filteredFriends: [String] = []
    
    var body: some View {
        VStack {
            List(friends, id: \.self) { friend in
                Text(friend)
            }
            .listStyle(.plain)
            .searchable(text: $search)
            .onChange(of: search) { newValue in
                if newValue.isEmpty {
                    // 검색어가 비어있을 때 모든 친구 목록 표시
                    filteredFriends = friends
                } else {
                    // 검색어로 필터링
                    filteredFriends = friends.filter { $0.contains(newValue) }
                }
            }
            Spacer()
        }.padding()
            .onAppear(perform: {
                filteredFriends = friends 
            })
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
```

- **`@State private var search: String = ""`**:
    - 검색창에 입력된 텍스트를 저장하는 상태 변수임. 사용자가 검색창에 입력하는 텍스트가 이 변수에 바인딩됨.
- **`@State private var friends: [String] = [...]`**:
    - 친구 목록을 저장하는 배열임. 이 배열은 검색을 위한 원본 데이터임.
- **`@State private var filteredFriends: [String] = []`**:
    - 검색어에 따라 필터링된 친구 목록을 저장하는 배열임. 사용자가 검색어를 입력할 때마다 이 배열의 내용이 업데이트됨.
- **`List(filteredFriends, id: \.self)`**:
    - 필터링된 친구 목록(`filteredFriends`)을 화면에 표시하는 리스트임. `id: \.self`는 배열의 값을 고유 식별자로 사용함.
- **`.searchable(text: $search)`**:
    - SwiftUI의 내장 검색 기능을 추가함. 검색 텍스트는 `@State` 변수인 `search`와 바인딩되어 사용자가 검색어를 입력하면 그 값이 자동으로 업데이트됨.
- **`.onChange(of: search)`**:
    - `search` 값이 변경될 때마다 실행되는 클로저임.
    - 검색어가 비어 있을 경우, `filteredFriends` 배열을 전체 친구 목록으로 설정함.
    - 검색어가 입력되면 `friends` 배열을 필터링하여 그 검색어를 포함한 친구들만 `filteredFriends` 배열에 저장함.
- **`.onAppear`**:
    - 뷰가 처음 나타날 때 `filteredFriends`를 초기화하여 처음에는 전체 친구 목록을 보여줌.

```swift
import SwiftUI

@main
struct LearnApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}
```

## Binding

```swift

import SwiftUI

struct LightBulbView: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        VStack {
            Image(systemName: isOn ? "lightbulb.fill": "lightbulb")
                .font(.largeTitle)
                .foregroundStyle(isOn ? .yellow: .black)
            Button("Toggle") {
                isOn.toggle()
            }
        }
    }
}

struct ContentView: View {
    
    @State private var isLightOn: Bool = false
    
    var body: some View {
        VStack {
            LightBulbView(isOn: $isLightOn)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isLightOn ? .black: .white)
    }
}

#Preview {
    ContentView()
}

```

- **`@Binding var isOn: Bool`**: `LightBulbView`는 부모 뷰(`ContentView`)로부터 `isOn` 상태를 바인딩하여 받아서 사용함. 즉, `LightBulbView` 내에서 `isOn` 값이 변경되면 그 변화는 부모 뷰에도 반영됨.
- **`Image(systemName: isOn ? "lightbulb.fill" : "lightbulb")`**:
    - `isOn`이 `true`이면 채워진 전구 아이콘인 `"lightbulb.fill"`을 표시하고, `false`이면 빈 전구 아이콘 `"lightbulb"`을 표시함.
- **`.foregroundStyle(isOn ? .yellow : .black)`**:
    - 전구가 켜져 있으면 아이콘 색을 노란색으로, 꺼져 있으면 검은색으로 설정함.
- **`Button("Toggle") { isOn.toggle() }`**:
    - 버튼을 누르면 `isOn` 값을 토글함. 즉, `true`이면 `false`로, `false`이면 `true`로 전환됨. 이때 **바인딩된 부모 뷰의 `isLightOn`도 같이 변함.**

---

- **`@State private var isLightOn: Bool = false`**:
    - `isLightOn`은 전구가 켜져 있는지 여부를 저장하는 상태 변수임. 초기값은 `false`로, 처음에는 전구가 꺼진 상태임.
- **`LightBulbView(isOn: $isLightOn)`**:
    - **`LightBulbView`를 호출할 때, `isLightOn` 상태를 바인딩으로 전달함. 이렇게 하면 자식 뷰에서 상태 변경이 일어나도 부모 뷰에 반영됨.**
- **`.background(isLightOn ? .black : .white)`**:
    - `isLightOn` 값에 따라 배경색을 검정 또는 흰색으로 설정함.
    - 전구가 켜지면 화면 배경이 검정색으로, 꺼지면 흰색으로 변경됨.

## Environment(Pre iOS 17)

- `@EnvironmentObject`를 사용하여 **전역 상태**를 관리하는 구조. `AppState`라는 전역 상태 객체를 여러 뷰에서 공유하고, 상태 변경에 따라 UI가 업데이트됨

```swift
import SwiftUI

@main
struct LearnSwiftUIApp: App {
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
```

- **`@StateObject private var appState = AppState()`**:
    - `@StateObject`는 `AppState` 객체를 앱의 **최상위**에서 한 번 생성하여 관리함. 이 객체는 뷰 계층 전반에 걸쳐 공유될 수 있음.
- **`.environmentObject(appState)`**:
    - `appState`를 `environmentObject`로 `ContentView`에 주입함. 이를 통해 뷰 계층 내에서 `@EnvironmentObject`로 `AppState`에 접근할 수 있음.

```swift

import SwiftUI

// Pre iOS 17
class AppState: ObservableObject {
    @Published var isOn: Bool = false
}

struct LightBulbView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            Image(systemName: appState.isOn ? "lightbulb.fill": "lightbulb")
                .font(.largeTitle)
                .foregroundStyle(appState.isOn ? .yellow: .black)
            Button("Toggle") {
                appState.isOn.toggle()
            }
        }
    }
}

struct LightRoomView: View {
    
    var body: some View {
        LightBulbView()
    }
}

struct ContentView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
          LightRoomView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appState.isOn ? .black: .white)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

```

**`@Published var isOn: Bool = false`**

- `AppState` 클래스는 `ObservableObject`를 따르며, `isOn` 상태가 변경될 때마다 이 상태를 참조하는 모든 뷰가 **자동으로 업데이트**됨.
- `isOn`은 전구가 켜져 있는지 여부를 나타내는 `Bool` 값임.

---

**`@EnvironmentObject private var appState: AppState`**:

- `@EnvironmentObject`를 통해 상위에서 주입된 `appState`를 가져와서 사용함. 이 객체는 전역 상태 객체로, 다른 뷰와 데이터를 공유함.

**`Button("Toggle")`**:

- 버튼을 누르면 `appState.isOn.toggle()`을 호출하여 `isOn` 상태를 반전시킴. 이 상태는 앱 전체에 걸쳐 반영됨.

---

- **`@EnvironmentObject private var appState: AppState`**:
    - `ContentView`에서도 `@EnvironmentObject`를 통해 전역 상태인 `appState`에 접근함.
- **`.background(appState.isOn ? .black : .white)`**:
    - `appState.isOn`의 값에 따라 배경색을 변경함.

---

미리보기에서는 `AppState`를 다시 생성하여 `ContentView`에 전달함. 실제 앱에서는 `@main`에서 주입된 `appState`가 사용됨.

## Environmnet(iOS 17 later)

이 코드는 **iOS 17** 이상에서 도입된 **Observation 프레임워크**와 **SwiftUI**를 사용하여 상태 관리를 하는 예제임. `@Observable`, `@Environment` 등의 최신 API를 사용하고 있음. 전구 상태를 전역적으로 관리하고, 이 상태에 따라 UI가 실시간으로 업데이트되도록 설계되어 있음.

### 주요 변경점

1. `@StateObject` 대신 **`@Observable`**과 **`@Environment`**를 사용하여 상태를 관리.
2. `@Bindable`로 바인딩된 상태를 뷰에서 수정 가능하게 함.
3. **iOS 17**에서 새롭게 등장한 `@Observable`과 `@Environment`의 통합 사용.

```swift
import SwiftUI

@main
struct LearnSwiftUIApp: App {
    
    @State private var appState = AppState()
    // @StateObject로 사용할 수도 있음
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
```

- **`@State private var appState = AppState()`**: `AppState` 객체를 앱의 전역 상태로 관리함.
- **`.environment(appState)`**: `AppState` 객체를 `@Environment`로 `ContentView`에 전달함. `environment`는 해당 상태를 모든 자식 뷰에서 사용할 수 있도록 제공함.

```swift

import SwiftUI
import Observation

@Observable
class AppState {
    var isOn: Bool = false
}

struct LightBulbView: View {
    
    @Environment(AppState.self) private var appState: AppState
    
    var body: some View {
        
        @Bindable var appState = appState
        
        VStack {
            Image(systemName: appState.isOn ? "lightbulb.fill": "lightbulb")
                .font(.largeTitle)
                .foregroundStyle(appState.isOn ? .yellow: .black)
            
            Toggle("IsOn", isOn: $appState.isOn)
            
            /*
            Button("Toggle") {
                appState.isOn.toggle()
            } */
        }
    }
}

struct LightRoomView: View {
    
    var body: some View {
        LightBulbView()
    }
}

struct ContentView: View {
    
    @Environment(AppState.self) private var appState: AppState
    
    var body: some View {
        VStack {
          LightRoomView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appState.isOn ? .black: .white)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}

```

**`@Observable`**: **iOS 17**에서 도입된 새로운 프로퍼티 래퍼로, `@Published`와 같은 역할을 함. `isOn` 값이 변경되면 이 값을 사용하는 모든 뷰가 자동으로 업데이트됨.

---

- **`@Environment(AppState.self) private var appState: AppState`**: `@Environment`를 통해 `AppState` 객체를 상위 뷰로부터 전달받음. 이제 `appState`에 접근하여 이 상태를 이용해 UI를 업데이트함.
- **`@Bindable var appState = appState`**: `@Bindable`은 `@Observable`과 함께 사용되는 최신 속성으로, **객체의 프로퍼티를 바인딩하여 뷰와 상호작용할 수 있도록 만듦. 이를 통해 `appState.isOn`을 직접 수정 가능함.**
- **`Toggle("IsOn", isOn: $appState.isOn)`**: 사용자가 토글을 변경하면 `appState.isOn` 값이 변경되고, 그에 따라 UI가 자동으로 업데이트됨.

---

- **`@Environment(AppState.self) private var appState: AppState`**: `@Environment`를 통해 상위 뷰로부터 `AppState` 객체를 받음.
- **`.background(appState.isOn ? .black : .white)`**: `appState.isOn` 값에 따라 배경색을 결정함.

