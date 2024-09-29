## APIEndpoint

각 케이스는 특정 API 요청의 URL을 생성하며, 기본적인 **위치 정보** 또는 **위도와 경도**를 통해 날씨 데이터를 가져오는 API를 호출할 수 있게 함.

```swift

import Foundation

enum APIEndpoint {
    
    static let baseURL = "https://api.openweathermap.org"
    
    case coordinatesByLocationName(String)
    case weatherByLatLon(Double, Double)
    
    private var path: String {
        switch self {
            case .coordinatesByLocationName(let city):
                return "/geo/1.0/direct?q=\(city)&appid=\(Constants.Keys.weatherAPIKey)"
            case .weatherByLatLon(let lat, let lon):
                return "/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.Keys.weatherAPIKey)"
        }
    }
    
    static func endpointURL(for endpoint: APIEndpoint) -> URL {
        let endpointPath = endpoint.path
        return URL(string: baseURL + endpointPath)!
    }
    
}
```

**`coordinatesByLocationName(String)`**: 도시 이름을 사용하여 좌표(위도와 경도)를 요청.

**`weatherByLatLon(Double, Double)`**: 위도와 경도를 사용하여 해당 지역의 날씨를 요청.

### **`static func endpointURL(for endpoint: APIEndpoint) -> URL`**

- 주어진 `APIEndpoint` 케이스에 대해 **완성된 URL**을 반환하는 메서드임.
- `endpoint.path`를 통해 각 엔드포인트의 경로를 가져오고, **`baseURL`*과 결합하여 **최종 URL**을 생성.
- 반환된 URL은 요청을 실행할 때 사용할 수 있는 **URL 객체.**

## Models

```swift
import Foundation

struct Location: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}

struct WeatherResponse: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
}
```

## GeocodingClient

**OpenWeatherMap API**를 사용해 도시 이름으로부터 좌표(위도, 경도)를 비동기적으로 요청하는 클라이언트를 구현. 요청이 실패하거나 응답이 유효하지 않을 경우 에러를 던지는 방식으로 설계. 주요 흐름은 도시 이름을 인자로 받아 **HTTP 요청을 수행**하고, **좌표 데이터를 반환**하는 방식.

```swift
import Foundation

enum NetworkError: Error {
    case invalidResponse
}

struct GeocodingClient {
    
    func coordinateByCity(_ city: String) async throws -> Location? {
        
        let (data, response) = try await URLSession.shared.data(from: APIEndpoint.endpointURL(for: .coordinatesByLocationName(city)))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let locations = try JSONDecoder().decode([Location].self, from: data)
        return locations.first
    }
    
}
```

- **`coordinateByCity(_ city: String) async throws -> Location?`**:
    - 비동기 함수로, 도시 이름을 인자로 받아 해당 도시의 좌표 정보를 반환함.
    - API 호출과 네트워크 통신에서 에러가 발생하면 **`throws`** 키워드를 통해 에러를 호출한 쪽에 던짐.
- **`URLSession.shared.data(from:)`**:
    - `URLSession`을 사용하여 API 요청을 보냄.
    - **`await`** 키워드를 통해 비동기적으로 데이터를 받음.
    - **`data`**: 서버로부터 응답받은 **데이터**.
    - **`response`**: 서버의 **HTTP 응답**.
- 응답 유효성 검사
    - **HTTP 응답**이 성공적인 상태 코드(200)를 반환하는지 확인
    - 상태 코드가 200이 아닐 경우, **`NetworkError.invalidResponse`** 에러를 던짐.
- `JSONDecoder`를 사용한 디코딩
    - 서버에서 받은 데이터를 **`[Location]`** 배열로 **디코딩**함.
    - 디코딩된 `locations` 배열에서 **첫 번째 위치**(도시와 일치하는 첫 번째 좌표)를 반환함.

### **API 호출 흐름**

1. **URL 생성**: `APIEndpoint.endpointURL(for: .coordinatesByLocationName(city))`를 통해 주어진 도시 이름으로 좌표를 요청하는 API의 URL을 생성함.
2. **네트워크 요청**: `URLSession.shared.data(from:)`을 통해 API 요청을 보내고, 비동기적으로 데이터를 받음.
3. **응답 검사**: 응답의 상태 코드가 200인지 확인함. 그렇지 않으면 **`NetworkError.invalidResponse`** 에러를 던짐.
4. **데이터 디코딩**: API로부터 받은 데이터를 **`JSONDecoder`*로 파싱하여 `Location` 배열로 디코딩하고, 첫 번째 요소를 반환함.

## WeatherClient

**`WeatherClient`** 구조체는 비동기적으로 날씨 데이터를 가져오고, 이를 디코딩하여 반환하는 역할을 함.

```swift
import Foundation

struct WeatherClient {
    
    func fetchWeather(location: Location) async throws -> Weather {
        
        let (data, response) = try await URLSession.shared.data(from: APIEndpoint.endpointURL(for: .weatherByLatLon(location.lat, location.lon)))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse.main 
    }
    
}
```

**`fetchWeather(location: Location) async throws -> Weather`**:

- 주어진 위치(`Location`)로부터 날씨 정보를 가져오는 비동기 함수임.
- 네트워크 요청과 JSON 디코딩 과정에서 에러가 발생할 수 있으므로, 함수는 **`throws`** 키워드를 사용함.

### **API 호출 흐름**

1. **URL 생성**: `APIEndpoint.endpointURL(for: .weatherByLatLon(location.lat, location.lon))`를 사용하여 위도와 경도를 기반으로 날씨 정보를 요청할 API URL을 생성함.
2. **네트워크 요청**: `URLSession.shared.data(from:)`으로 OpenWeatherMap API에 요청을 보냄. 비동기 방식으로 데이터를 받아옴.
3. **응답 검사**: HTTP 응답 상태 코드가 200(성공)인지 확인함. 그렇지 않으면 `NetworkError.invalidResponse`를 던짐.
4. **데이터 디코딩**: 받은 JSON 데이터를 `WeatherResponse` 타입으로 디코딩하고, 그 중 `main` 속성만을 반환함.

## MeasurementFormatter+Extensions

```swift
import Foundation

extension MeasurementFormatter {
    
    static func temperature(value: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = numberFormatter
        
        let temp = Measurement(value: value, unit: UnitTemperature.kelvin)
        
        return formatter.string(from: temp)
    }
    
}
```

## ContentView

도시 이름을 입력받아, 해당 도시의 날씨를 비동기적으로 가져와 화면에 표시하는 앱의 UI를 구현한 예제임. **GeocodingClient**를 통해 도시 이름을 좌표로 변환하고, **WeatherClient**를 통해 날씨 데이터를 가져와 표시.

```swift

import SwiftUI

struct ContentView: View {
    
    @State private var city: String = ""
    @State private var isFetchingWeather: Bool = false
    
    let geocodingClient = GeocodingClient()
    let weatherClient = WeatherClient()
    
    @State private var weather: Weather?
    
    private func fetchWeather() async {
        do {
            guard let location = try await geocodingClient.coordinateByCity(city) else { return }
            weather = try await weatherClient.fetchWeather(location: location)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            TextField("City", text: $city)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    isFetchingWeather = true
                }.task(id: isFetchingWeather) {
                    if isFetchingWeather {
                        await fetchWeather()
                        isFetchingWeather = false
                        city = ""
                    }
                }
            
            Spacer()
            if let weather {
                Text(MeasurementFormatter.temperature(value: weather.temp))
                    .font(.system(size: 100))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

```

**1. 상태 및 클라이언트 초기화**

- **`city`**: 사용자로부터 입력받은 도시 이름을 저장하는 상태 변수.
- **`isFetchingWeather`**: 날씨 데이터를 가져오는 중인지 여부를 나타내는 상태 변수. 이를 통해 데이터를 가져오는 동안 UI를 업데이트하거나 로딩 상태를 관리할 수 있음.
- **`weather`**: 날씨 데이터(`Weather` 객체)를 저장하는 상태 변수. 이 값이 설정되면 화면에 날씨 정보를 표시함.
- `geocodingClient`와 `weatherClient`는 각각 지오코딩(좌표 변환)과 날씨 데이터를 가져오는 역할을 수행하는 클라이언트 객체임.

**2. `fetchWeather()` 함수**

- **비동기 함수**로 도시 이름을 이용해 위치 정보를 먼저 가져오고, 해당 위치의 날씨 데이터를 가져와서 `weather` 상태에 저장함.
- **`guard`**: 위치 정보를 성공적으로 받아온 경우에만 날씨 정보를 요청함.
- **에러 처리**: `do-catch` 구문을 통해 네트워크 요청 실패 시 에러를 출력함.

**3. TextField와 비동기 태스크**

- **TextField**: 사용자가 도시 이름을 입력할 수 있는 텍스트 필드. 입력 후 **엔터**를 누르면 `onSubmit`이 호출되어 `isFetchingWeather`가 `true`로 설정됨.
- **`task(id: isFetchingWeather)`**: `isFetchingWeather`가 변할 때마다 새로운 비동기 태스크를 실행함. 이 경우 `isFetchingWeather`가 `true`일 때 날씨 데이터를 가져오고, 작업이 완료되면 다시 `false`로 설정하여 작업이 완료됨을 표시함.

**4. 날씨 데이터 표시**

- **날씨 데이터가 있을 경우** (`weather != nil`), 해당 데이터에서 **온도**를 가져와 텍스트로 화면에 표시함.
- **온도 표시 형식**: `MeasurementFormatter`를 사용하여 온도를 읽기 쉬운 형식으로 변환해 줌.

**5. UI 구성**

- 전체적인 UI는 **VStack**으로 구성되어 있음.
- 텍스트 필드에서 도시 이름을 입력한 후 **엔터**를 누르면 날씨 데이터를 가져오고, 하단에 큰 글씨로 온도를 표시함.

### 결과 흐름

1. 사용자가 도시 이름을 입력한 후 엔터를 누르면, `isFetchingWeather`가 `true`로 설정됨.
2. **비동기 태스크**가 시작되어 `fetchWeather()`를 호출. 이 함수는 먼저 도시의 좌표를 가져오고, 그 좌표를 기반으로 날씨 데이터를 가져옴.
3. 데이터가 성공적으로 받아지면, 화면에 해당 도시의 **온도**를 표시함.
