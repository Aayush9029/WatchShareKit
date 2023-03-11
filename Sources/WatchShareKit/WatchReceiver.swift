//
//  WatchReceiver.swift
//  WatchShareKit
//
//  Created by Aayush Pokharel on 2023-03-10.
//

#if os(watchOS)

import SwiftUI
import WatchConnectivity

class WatchReceiver: NSObject, ObservableObject {
    @Published var gotMessage: [String: Any]?
    @Published var gotData: Data?

    let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchReceiver: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            NSLog("WatchShareKit | WatchReceiver | ❌ Session activation failed with error: \(error.localizedDescription)")
            return
        }
        NSLog("WatchShareKit | WatchReceiver | ✅ Session activated with state: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            self.gotMessage = message
        }
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            self.gotData = messageData
        }
    }
}

#endif
