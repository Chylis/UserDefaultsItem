import Foundation

@propertyWrapper
struct UserDefaultsItem<T> {
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
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
            storage.synchronize()
        }
    }
}
