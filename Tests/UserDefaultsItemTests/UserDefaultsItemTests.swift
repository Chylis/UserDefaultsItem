import XCTest
@testable import UserDefaultsItem

final class UserDefaultsItemTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UserDefaultsItem().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
