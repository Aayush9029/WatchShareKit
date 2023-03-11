//
//  PhoneSender.swift
//  WatchShareKit
//
//  Created by Aayush Pokharel on 2023-03-10.
//

#if os(iOS)

import SwiftUI
import WatchConnectivity

struct SheetData {
    var title: String
    var detail: String
    var button: String
    var image: String
    let done: String = "Done"

    static let defaultSheet = SheetData(
        title: "Share Password",
        detail: "Do you want to share password with Apple Watch?",
        button: "Share Password",
        image: "key.fill"
    )
}

enum ShareState {
    case none, initialized, sharing, shared, error
}

class PhoneSender: NSObject, ObservableObject {
    @Published var shareSheetPresented: Bool = false
    @Published var sheetData: SheetData = .defaultSheet
    @Published var shareState: ShareState = .none

    let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            changeState(.initialized)
        }
    }

    func sendString(_ message: [String: Any]) {
        changeState(.sharing)
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: { _ in
                self.changeState(.error)

            })
        } else {
            changeState(.error)
        }
        changeState(.shared)
    }

    func sendData(_ data: Data) {
        changeState(.sharing)
        if session.isReachable {
            session.sendMessageData(data, replyHandler: nil) { _ in
                self.changeState(.error)
            }
        } else {
            changeState(.error)
        }
        changeState(.shared)
    }

    func isSupported() -> Bool { return WCSession.isSupported() }
    func isPaired() -> Bool { return session.isPaired }
    func isReachable() -> Bool { return session.isReachable }
}

extension PhoneSender: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            NSLog("WatchShareKit | PhoneSender | ❌ Session activation failed with error: \(error.localizedDescription)")
            return
        }
        NSLog("WatchShareKit | PhoneSender | ✅ Session activated with state: \(activationState.rawValue)")
    }

    private func changeState(_ newState: ShareState) {
        DispatchQueue.main.async {
            self.shareState = newState
        }
    }
}

#endif
