## List

- 기본 리스트 세팅

```swift
//
//  ContentView.swift
//  Hiking

import SwiftUI

struct ContentView: View {
    
    let hikes = [
        Hike(name: "Salmonberry Trail", photo: "sal", miles: 6),
        Hike(name: "Tom, Dick, and Harry Mountain", photo: "tom", miles: 5.8),
        Hike(name: "Tamanawas Falls", photo: "tam", miles: 5)
    ]
    
    var body: some View {
        List(hikes) { hike in
        // cell UI
            HStack(alignment: .top) {
                Image(hike.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    // 프레임 안에 비율 유지한 채로 이미지가 채워짐
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    // 둥근사각형 모양으로 이미지 자르기
                    .frame(width: 100)
                    // 이미지 사이즈 조절
                   
                VStack(alignment: .leading) {
                    Text(hike.name)
                    Text("\(hike.miles.formatted()) miles")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
```

## 리스트의 cell 클릭 시 Navigation

- 리스트를 NavigationStack으로 감싸고, Link연결

### NavigationStack

새로운 화면이 추가되면 이전 화면이 뒤로가기 버튼으로 숨겨짐

```swift
    var body: some View {
        NavigationStack {
            List(hikes) { hike in
                NavigationLink(value: hike) {
                // 셀에 Navigation link 연결해줌
                    HikeCellView(hike: hike)
                }
            }.navigationTitle("Hikes")
            // 연결된 navigation link가 어디로 연결되었는지 설명
            .navigationDestination(for: Hike.self) { hike in
                Text(hike.name)
                // 텍스트만 띄운 화면 보여줌
            }
        }
    }
    
...
// 셀 안의 뷰 따로 빼주기(Extract function)
struct HikeCellView: View {
    
    let hike: Hike
    
    var body: some View {
        HStack(alignment: .top) {
            Image(hike.photo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .frame(width: 100)
            
            VStack(alignment: .leading) {
                Text(hike.name)
                Text("\(hike.miles.formatted()) miles")
            }
        }
    }
}
```

## Navigation으로 이동할 페이지 정의

- 단순한 Text만 띄우는 뷰를 HikeDetailScreen으로 정의해줌

```swift
    var body: some View {
        NavigationStack {
            List(hikes) { hike in
                NavigationLink(value: hike) {
                    HikeCellView(hike: hike)
                }
            }.navigationTitle("Hikes")
            .navigationDestination(for: Hike.self) { hike in
                HikeDetailScreen(hike: hike)
            }
        }
    }
```

```swift
import SwiftUI
// 네비게이션 링크로 새로 띄울 뷰 정의
struct HikeDetailScreen: View {
    
    let hike: Hike
    
    var body: some View {
        VStack {
            Image(hike.photo)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(hike.name)
                .font(.title)
            Text("\(hike.miles.formatted()) miles")
            Spacer()
        }.navigationTitle(hike.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HikeDetailScreen(hike: Hike(name: "Salmonberry Trail", photo: "sal", miles: 6))
    }
}
```

- navigationTitle로 설정한 Title을 어떻게 보여줄지 정하는 옵션 : navigationTitleDisplayMode로 결정

### NavigationBarTitleDisplayMode

- `.inline`: 제목이 작고, 화면 상단에 가깝게 표시됩니다. 상위 뷰에서 하위 뷰로 이동 시 보통 사용합니다.
- `.large`: 제목이 큼직하게 표시되며, 화면의 상단 부분을 많이 차지합니다. 보통 목록의 루트 뷰에서 사용합니다.
- `.automatic`: SwiftUI가 자동으로 모드를 선택합니다. (대개 상위 뷰는 큰 제목, 하위 뷰는 작은 제목으로 설정됩니다.)

## Tap & Animation

```swift
import SwiftUI

struct HikeDetailScreen: View {
    
    let hike: Hike
    @State private var zoomed: Bool = false
    
    var body: some View {
        VStack {
            Image(hike.photo)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill: .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            Text(hike.name)
                .font(.title)
            Text("\(hike.miles.formatted()) miles")
            Spacer()
        }.navigationTitle(hike.name)
        .navigationBarTitleDisplayMode(.inline)
    }
```

### `@State private var zoomed: Bool = false`

- `@State`는 SwiftUI에서 상태를 관리하는 프로퍼티 wrapper. 여기서는 `zoomed`라는 `Bool` 변수를 상태로 정의하였고, 기본값은 `false`
- 이 `zoomed` 값은 이미지의 확대 여부를 결정하는 데 사용
- `@State`는 값이 변경될 때마다 뷰를 다시 렌더링하므로, 이미지의 크기 변화가 즉시 화면에 반영됨

### `.aspectRatio(contentMode: zoomed ? .fill : .fit)`

- `aspectRatio`는 이미지의 비율을 유지하면서 어떻게 뷰 내에서 렌더링할지를 결정한다.
- `contentMode`로 `zoomed` 값에 따라 두 가지 모드 중 하나를 선택:
    - `.fill`: 이미지를 뷰의 크기에 맞추어 채움. 이 과정에서 이미지가 잘릴 수 있지만 뷰의 공간을 완전히 차지합니다. `zoomed`가 `true`일 때 사용
    - `.fit`: 이미지를 뷰의 크기에 맞게 맞춤. 이미지의 비율을 유지하면서 전체가 화면에 보이도록 합니다. `zoomed`가 `false`일 때 사용
- `zoomed` 값이 `true`이면 `.fill`로 설정되고, `false`이면 `.fit`으로 설정되어 확대 또는 축소 효과 유발

### `.onTapGesture { ... }`

- `onTapGesture`는 사용자가 이미지를 터치할 때 실행되는 제스처 이벤트
- 사용자가 이미지를 탭하면 클로저 내부의 코드가 실행

### `withAnimation { zoomed.toggle() }`

- `withAnimation`은 애니메이션을 적용하여 상태 변화를 부드럽게 나타냄
- `zoomed.toggle()`은 `zoomed` 값의 true/false를 반전.
- 이 변경에 따라 이미지의 `aspectRatio`가 `.fill`과 `.fit` 사이에서 전환되며, 이 과정이 애니메이션으로 표현됨

### 삼항 연산자 대신에 if-else문 사용한 코드
```swift
struct HikeDetailScreen: View {
    
    let hike: Hike
    @State private var zoomed: Bool = false
    
    var body: some View {
        VStack {
            Image(hike.photo)
                .resizable()
                .aspectRatio(contentMode: {
                    if zoomed {
                        return .fill
                    } else {
                        return .fit
                    }
                }())
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            Text(hike.name)
                .font(.title)
            Text("\(hike.miles.formatted()) miles")
            Spacer()
        }
        .navigationTitle(hike.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

```
