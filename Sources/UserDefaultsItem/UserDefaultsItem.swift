import Foundation


@propertyWrapper
public struct UserDefaultsItem<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults
    
    public init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    public var wrappedValue: T {
        get {
            guard let data = storage.object(forKey: key) as? Data,
                let decodedValue = try? JSONDecoder().decode(T.self, from: data) else {
                    return defaultValue
            }
            return decodedValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                storage.set(data, forKey: key)
                storage.synchronize()
            } catch {
                print("Failed persisting user defaults item: \(newValue), error: \(error)")
            }
        }
    }
}
