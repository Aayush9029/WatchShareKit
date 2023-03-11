//
//  ContentView.swift
//  WatchShareKitExample
//
//  Created by Aayush Pokharel on 2023-03-10.
//

import SwiftUI
import WatchConnectivity
import WatchShareKit

struct ContentView: View {
    @State private var message: [String: Any] = ["your-key": "value"]
    @StateObject var phoneSender: PhoneSender = .init()

    var body: some View {
        VStack {
            if phoneSender.isPaired() {
                Button("Share Password") {
                    phoneSender.shareSheet.toggle()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $phoneSender.shareSheetPresented) {
                    ShareKeys(message: message)
                        .environmentObject(phoneSender)
                }
            } else {
                Text("Apple Watch Not Paired")
            }
        }
        .onChange(of: phoneSender.shareState) { newState in
            if newState == .shared {
                phoneSender.shareSheet.toggle()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
