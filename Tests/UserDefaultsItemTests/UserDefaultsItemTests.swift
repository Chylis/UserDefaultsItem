import XCTest
@testable import UserDefaultsItem


struct CodableStruct: Equatable, Codable {
    var str: String
    var int: Int
}

private let name1 = "defaultName"
private let name2 = "new name"
private let struct1 = CodableStruct(str: "str", int: 123)
private let struct2 = CodableStruct(str: "rts", int: 321)

struct UserSettings {
    @UserDefaultsItem(key: "username", defaultValue: name1)
    var username: String
    
    @UserDefaultsItem(key: "struct", defaultValue: struct1)
    var `struct`: CodableStruct
}

// The tests are executed in alphabetical order, thus the naming test1, test2, test3, etc...
final class UserDefaultsItemTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        var settings = UserSettings()
        settings.username = name1
        settings.struct = struct1
    }
    
    func test1_DefaultValues() {
        let settings = UserSettings()
        XCTAssertEqual(settings.username, name1)
        XCTAssertEqual(settings.struct, struct1)
    }
    
    func test2_UpdateValues() {
        var settings = UserSettings()
        settings.username = name2
        settings.struct = struct2
        XCTAssertEqual(settings.username, name2)
        XCTAssertEqual(settings.struct, struct2)
    }
    
    func test3_PersistedValues() {
        XCTAssertEqual(UserSettings().username, name2)
        XCTAssertEqual(UserSettings().struct, struct2)
    }
}
