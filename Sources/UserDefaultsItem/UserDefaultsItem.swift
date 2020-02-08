import Foundation

@propertyWrapper
struct UserDefaultsItem<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
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
            let data = try! JSONEncoder().encode(newValue)
            storage.setValue(data, forKey: key)
            storage.synchronize()
        }
    }
}
