import XCTest
@testable import UserDefaultsItem

private let name1 = "defaultName"
private let name2 = "new name"

struct UserSettings {
    @UserDefaultsItem(key: "username", defaultValue: name1)
    var username: String
}

// The tests are executed in alphabetical order, thus the naming test1, test2, test3, etc...
final class UserDefaultsItemTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        var settings = UserSettings()
        settings.username = name1
    }
    
    func test1_DefaultValues() {
        let settings = UserSettings()
        XCTAssertEqual(settings.username, name1)
    }
    
    func test2_UpdateValues() {
        var settings = UserSettings()
        settings.username = name2
        XCTAssertEqual(settings.username, name2)
    }
    
    func test3_PersistedValues() {
        XCTAssertEqual(UserSettings().username, name2)
    }
}
