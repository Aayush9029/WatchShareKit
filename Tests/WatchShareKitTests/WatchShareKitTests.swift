@testable import WatchShareKit
import Testing

@Suite("WatchShareKit Tests")
struct WatchShareKitTests {
    @Test("Package imports on the host platform")
    func packageImports() {
        #expect(Bool(true))
    }
}
