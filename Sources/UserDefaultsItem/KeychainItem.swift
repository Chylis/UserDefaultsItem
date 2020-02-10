import Foundation

@propertyWrapper
public struct KeychainItem {
    /// Dynamic lookup value used to retrieve values from the keychain.
    private let account: String
    
    public init(account: String) {
        self.account = account
    }

    public var wrappedValue: String? {
        get {
            do {
                return try GenericPasswordKeychainService().entryForAccount(account)
            } catch {
                fatalError("Keychain error occurred while fetching entry")
            }
        }
        set {
            do {
                if let newValue = newValue {
                    try GenericPasswordKeychainService().save(value: newValue, account: account)
                } else {
                    try GenericPasswordKeychainService().deleteEntryForAccount(account)
                }
            } catch {
                fatalError("Keychain error occurred while saving entry")
            }
        }
    }
}


//MARK: - GenericPasswordKeychainService

public final class GenericPasswordKeychainService {
    
    //MARK: Public
    
    public enum KeychainError: Error {
        case noPassword
        case badFormat
        case unhandledError(status: OSStatus)
    }
    
    /// Attempts to fetch and return the GenericPassword value stored under the received account name.
    /// - return the stored password, or nil if no password was found
    /// - throws KeychainError if an error occurs
    public func entryForAccount(_ account: String) throws -> String? {
        let query: [String: Any] = [
            (kSecClass as String): kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            (kSecMatchLimit as String): kSecMatchLimitOne,
            // Specify the desired return type of the query as a CFDataRef.
            // For keys and password items, data is encrypted and may require the user to enter a password for access.
            (kSecReturnData as String): true
        ]
        
        var keychainItem: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &keychainItem)
        guard status != errSecItemNotFound else {
            return nil
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        guard let secretData = keychainItem as? Data,
            let secretString = String(data: secretData, encoding: .utf8) else {
                throw KeychainError.badFormat
        }
        return secretString
    }
    
    public func save(value: String, account: String) throws {
          let existsInKeychain = try entryForAccount(account) != nil
          if existsInKeychain {
              try updateKeychainItem(value: value, account: account)
          } else {
              try createKeychainItem(value: value, account: account)
          }
      }
    
    public func deleteEntryForAccount(_ account: String) throws {
        let query: [String: Any] = [
            (kSecClass as String): kSecClassGenericPassword,
            (kSecAttrAccount as String): account,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    //MARK: Private
    
    private func createKeychainItem(value: String, account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.badFormat
        }
        let entry: [String: Any] = [
            (kSecClass as String): kSecClassGenericPassword,
            (kSecAttrAccount as String): account,
            (kSecValueData as String): data
        ]
        let status = SecItemAdd(entry as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private func updateKeychainItem(value: String, account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.badFormat
        }
        let query: [String: Any] = [
            (kSecClass as String): kSecClassGenericPassword,
            (kSecAttrAccount as String): account,
        ]
        let newValue: [String: Any] = [(kSecValueData as String) : data]
        let status = SecItemUpdate(query as CFDictionary, newValue as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
