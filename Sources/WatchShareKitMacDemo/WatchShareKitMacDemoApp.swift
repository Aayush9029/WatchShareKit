import Darwin
import Foundation
import SwiftUI
import WatchShareKit

@main
struct WatchShareKitMacDemoApp: App {
    init() {
        if CommandLine.arguments.contains("--smoke-test") {
            SmokeTest.run()
            exit(0)
        }
    }

    var body: some Scene {
        WindowGroup {
            MacDemoView()
                .frame(minWidth: 720, minHeight: 460)
        }
    }
}

enum SmokeTest {
    static func run() {
        do {
            let payload = SharePayload(
                service: "Demo Service",
                account: "demo@example.com",
                secret: "sample-secret",
                metadata: ["source": "mac-demo"]
            )
            let data = try payload.encodedData()
            let decoded = try SharePayload.decoded(from: data)
            guard decoded == payload else {
                fputs("WatchShareKitMacDemo smoke test failed: payload mismatch\n", stderr)
                exit(1)
            }
            print("WatchShareKitMacDemo smoke test encoded \(data.count) bytes")
        } catch {
            fputs("WatchShareKitMacDemo smoke test failed: \(error)\n", stderr)
            exit(1)
        }
    }
}

struct MacDemoView: View {
    @State private var service = "Native Twitch"
    @State private var account = "aayush@example.com"
    @State private var secret = "watch-share-token"
    @State private var shareState = ShareState.initialized
    @State private var encodedPayload = ""

    private let sheetData = SheetData.defaultSheet

    var body: some View {
        NavigationSplitView {
            PayloadEditor(
                service: $service,
                account: $account,
                secret: $secret,
                shareState: shareState,
                encode: encodePayload,
                reset: reset
            )
            .navigationSplitViewColumnWidth(min: 300, ideal: 340)
        } detail: {
            PayloadPreview(
                title: sheetData.title,
                detail: sheetData.detail,
                buttonTitle: sheetData.button,
                imageName: sheetData.image,
                state: shareState,
                encodedPayload: encodedPayload
            )
        }
    }

    private func encodePayload() {
        do {
            shareState = .sharing
            let payload = SharePayload(
                service: service,
                account: account,
                secret: secret,
                metadata: ["platform": "macOS"]
            )
            let data = try payload.encodedData()
            encodedPayload = String(data: data, encoding: .utf8) ?? ""
            shareState = .shared
        } catch {
            encodedPayload = error.localizedDescription
            shareState = .error
        }
    }

    private func reset() {
        encodedPayload = ""
        shareState = .initialized
    }
}

struct PayloadEditor: View {
    @Binding var service: String
    @Binding var account: String
    @Binding var secret: String
    let shareState: ShareState
    let encode: () -> Void
    let reset: () -> Void

    var body: some View {
        Form {
            Section("Payload") {
                TextField("Service", text: $service)
                TextField("Account", text: $account)
                SecureField("Secret", text: $secret)
            }

            Section("State") {
                LabeledContent("Current", value: displayName(for: shareState))
            }

            Section {
                Button("Encode Payload", systemImage: "lock.doc") {
                    encode()
                }
                .disabled(service.isEmpty || account.isEmpty || secret.isEmpty)

                Button("Reset", systemImage: "arrow.counterclockwise") {
                    reset()
                }
            }
        }
        .formStyle(.grouped)
    }

    private func displayName(for state: ShareState) -> String {
        switch state {
        case .none: return "None"
        case .initialized: return "Initialized"
        case .sharing: return "Sharing"
        case .shared: return "Shared"
        case .error: return "Error"
        }
    }
}

struct PayloadPreview: View {
    let title: String
    let detail: String
    let buttonTitle: String
    let imageName: String
    let state: ShareState
    let encodedPayload: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ShareSheetSummary(
                title: title,
                detail: detail,
                buttonTitle: buttonTitle,
                imageName: imageName
            )

            Divider()

            EncodedPayloadView(state: state, encodedPayload: encodedPayload)
        }
        .padding(28)
    }
}

struct ShareSheetSummary: View {
    let title: String
    let detail: String
    let buttonTitle: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: imageName)
                .font(.title2)
                .fontWeight(.semibold)

            Text(detail)
                .foregroundStyle(.secondary)

            Button(buttonTitle, systemImage: "applewatch") {}
                .disabled(true)
        }
    }
}

struct EncodedPayloadView: View {
    let state: ShareState
    let encodedPayload: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(displayName(for: state), systemImage: systemImage(for: state))
                .font(.headline)

            ScrollView {
                Text(encodedPayload.isEmpty ? "{}" : encodedPayload)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .background(.quaternary.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func displayName(for state: ShareState) -> String {
        switch state {
        case .none: return "None"
        case .initialized: return "Initialized"
        case .sharing: return "Sharing"
        case .shared: return "Shared"
        case .error: return "Error"
        }
    }

    private func systemImage(for state: ShareState) -> String {
        switch state {
        case .none: return "circle"
        case .initialized: return "checkmark.circle"
        case .sharing: return "arrow.up.circle"
        case .shared: return "checkmark.seal"
        case .error: return "exclamationmark.triangle"
        }
    }
}
