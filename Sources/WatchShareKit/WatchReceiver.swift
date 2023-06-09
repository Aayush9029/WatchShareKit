//
//  WatchReceiver.swift
//  WatchShareKit
//
//  Created by Aayush Pokharel on 2023-03-10.
//

#if os(watchOS)

import SwiftUI
import WatchConnectivity

public class WatchReceiver: NSObject, ObservableObject {
    @Published public var gotMessage: [String: Any]?
    @Published public var gotData: Data?

    public let session: WCSession

    public init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchReceiver: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            NSLog("WatchShareKit | WatchReceiver | ❌ Session activation failed with error: \(error.localizedDescription)")
            return
        }
        NSLog("WatchShareKit | WatchReceiver | ✅ Session activated with state: \(activationState.rawValue)")
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            self.gotMessage = message
        }
    }

    public func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            self.gotData = messageData
        }
    }
}

#endif
