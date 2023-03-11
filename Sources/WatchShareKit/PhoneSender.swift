//
//  PhoneSender.swift
//  WatchShareKit
//
//  Created by Aayush Pokharel on 2023-03-10.
//

#if os(iOS)

import SwiftUI
import WatchConnectivity

public struct SheetData {
    public var title: String
    public var detail: String
    public var button: String
    public var image: String
    public let done: String = "Done"

    public static let defaultSheet = SheetData(
        title: "Share Password",
        detail: "Do you want to share password with Apple Watch?",
        button: "Share Password",
        image: "key.fill"
    )
}

public enum ShareState {
    case none, initialized, sharing, shared, error
}

public class PhoneSender: NSObject, ObservableObject {
    @Published public var shareSheet: Bool = false
    @Published public var sheetData: SheetData = .defaultSheet
    @Published public var shareState: ShareState = .none

    public let session: WCSession

    public init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            changeState(.initialized)
        }
    }

    public func sendString(_ message: [String: Any]) {
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

    public func sendData(_ data: Data) {
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

    public func isSupported() -> Bool { return WCSession.isSupported() }
    public func isPaired() -> Bool { return session.isPaired }
    public func isReachable() -> Bool { return session.isReachable }
}

extension PhoneSender: WCSessionDelegate {
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    public func sessionDidDeactivate(_ session: WCSession) {}

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
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
