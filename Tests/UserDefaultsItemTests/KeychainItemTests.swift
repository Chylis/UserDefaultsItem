import XCTest
@testable import UserDefaultsItem


private struct CodableStruct: Equatable, Codable {
    var str: String
    var int: Int
}

private let accountName = "testAccount"
private let name1 = "defaultName"
private let name2 = "new name"
private let name3 = "newest name"

private struct KeychainSettings {
    @KeychainItem(account: accountName)
    var username: String?
}


// The tests are executed in alphabetical order, thus the naming test1, test2, test3, etc...
final class KeychainItemTests: XCTestCase {
    
    private static let keychainService = GenericPasswordKeychainService()
    
    private var service: GenericPasswordKeychainService {
        return KeychainItemTests.keychainService
    }
    
    override class func setUp() {
        super.setUp()
        try? keychainService.deleteEntryForAccount(accountName)
    }
    
    func test1_DeleteNonExistingValueFromKeychain() {
        XCTAssertTrue(try! service.entryForAccount(accountName) == nil)
        var settings = KeychainSettings()
        settings.username = nil
        XCTAssertEqual(settings.username, nil)
        XCTAssertTrue(try! service.entryForAccount(accountName) == nil)
    }
    
    func test2_CreateNewEntry() {
        XCTAssertTrue(try! service.entryForAccount(accountName) == nil)
        var settings = KeychainSettings()
        settings.username = name1
        XCTAssertEqual(settings.username, name1)
        XCTAssertTrue(try! service.entryForAccount(accountName) == name1)
    }
    
    func test3_UpdateExistingValue() {
        XCTAssertFalse(try! service.entryForAccount(accountName) == nil)
        var settings = KeychainSettings()
        XCTAssertEqual(KeychainSettings().username, name1)
        settings.username = name2
        settings.username = name3
        XCTAssertEqual(settings.username, name3)
    }
    
    func test4_PersistedValues() {
        XCTAssertFalse(try! service.entryForAccount(accountName) == nil)
        XCTAssertEqual(KeychainSettings().username, name3)
        XCTAssertTrue(try! service.entryForAccount(accountName) == name3)
    }
    
    func test5_DeleteFromKeychain() {
        var settings = KeychainSettings()
        settings.username = nil
        XCTAssertTrue(try! service.entryForAccount(accountName) == nil)
    }
}
