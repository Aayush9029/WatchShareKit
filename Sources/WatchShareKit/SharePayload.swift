import Foundation

public struct SheetData: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var button: String
    public var image: String
    public let done: String = "Done"

    public init(title: String, detail: String, button: String, image: String) {
        self.title = title
        self.detail = detail
        self.button = button
        self.image = image
    }

    public static let defaultSheet = SheetData(
        title: "Share Password",
        detail: "Do you want to share password with Apple Watch?",
        button: "Share Password",
        image: "key.fill"
    )
}

public enum ShareState: Equatable, Sendable {
    case none
    case initialized
    case sharing
    case shared
    case error
}

public struct SharePayload: Codable, Equatable, Sendable {
    public var service: String
    public var account: String
    public var secret: String
    public var metadata: [String: String]

    public init(
        service: String,
        account: String,
        secret: String,
        metadata: [String: String] = [:]
    ) {
        self.service = service
        self.account = account
        self.secret = secret
        self.metadata = metadata
    }

    public func encodedData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }

    public static func decoded(
        from data: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> SharePayload {
        try decoder.decode(SharePayload.self, from: data)
    }
}
