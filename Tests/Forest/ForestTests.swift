import XCTest
@testable import Forest

class ForestTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Forest().text, "Hello, World!")
    }


    static var allTests : [(String, (ForestTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
