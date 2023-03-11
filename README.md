
<div align="center">
  <img src="https://user-images.githubusercontent.com/43297314/224458436-20a3d49d-63f2-45a4-a8dc-d0278b5fef61.png" height="256">
  <h1 align="center">WatchShareKit</h1>
  WatchShareKit is a sender and receiver library used to send secrets from iOS apps to watchOS apps.

  <a href="https://www.buymeacoffee.com/swiftdev" target="_blank"><img src="https://user-images.githubusercontent.com/43297314/167192051-dc8cfd47-1c2d-43f1-bb95-275ae70ef8dd.svg" alt="Buy Me coffee" ></a>

<img src="https://user-images.githubusercontent.com/43297314/224458959-891955fe-242e-4717-ad9e-a79ccddb0f86.png" width="320"> &nbsp;
<img src="https://user-images.githubusercontent.com/43297314/224458962-b9a621db-4c0a-4c6f-97f5-71fe8f76ea84.png" width="320">
</div>



---

## Usage

### 📲 Sender 

```swift

import SwiftUI
import WatchConnectivity
import WatchShareKit

struct ContentView: View {
    @StateObject var phoneSender: PhoneSender = .init()
    @State private var message: [String: Any] = ["your-key": "value"]
    
    var body: some View {
        VStack {
            if phoneSender.isPaired() {
                Button("Share Password") {
                    phoneSender.shareSheet.toggle()
                }
                .sheet(isPresented: $phoneSender.shareSheetPresented) {
                    ShareKeys(message: message)
                        .environmentObject(phoneSender)
                }
            } else { Text("Apple Watch Not Paired") }
        }
        .onChange(of: phoneSender.shareState) { newState in
            if newState == .shared { phoneSender.shareSheet.toggle() }
        }
    }
}

```

You can also use `.onAppear` and toggle sheet accordingly for seamingless experience.

### ⌚ Reciever 

```swift

import SwiftUI
import WatchConnectivity
import WatchShareKit

struct ContentView: View {
    @StateObject var watchReceiver: WatchReceiver = .init()
    
    var body: some View {
        VStack {
            if let message = watchReceiver.gotMessage {
                Text(message["your-key"].value)
            }
        }
    }
}
```

You can also use `.onChange` to manipulate the data accordingly.

---

Used by [Native Twitch](https://github.com/Aayush9029/NativeTwitch/tree/v3)
