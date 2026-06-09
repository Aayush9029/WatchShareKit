@testable import WatchShareKit
import Testing

@Suite("WatchShareKit Tests")
struct WatchShareKitTests {
    @Test("Package imports on the host platform")
    func packageImports() {
        #expect(Bool(true))
    }

    @Test("SharePayload round trips as JSON data")
    func sharePayloadRoundTrip() throws {
        let payload = SharePayload(
            service: "Example",
            account: "user@example.com",
            secret: "token",
            metadata: ["scope": "demo"]
        )

        let data = try payload.encodedData()
        let decoded = try SharePayload.decoded(from: data)

        #expect(decoded == payload)
    }

    @Test("SheetData defaults stay stable")
    func sheetDataDefaults() {
        #expect(SheetData.defaultSheet.title == "Share Password")
        #expect(SheetData.defaultSheet.image == "key.fill")
        #expect(SheetData.defaultSheet.done == "Done")
    }
}
