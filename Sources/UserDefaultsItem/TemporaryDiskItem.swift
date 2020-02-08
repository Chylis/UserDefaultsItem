import Foundation

/// An item that is persisted to the NSTemporaryDirectory. Cleared every ~3 days.
@propertyWrapper
public struct TemporaryDiskItem<T: Codable> {
    private let filename: String
    private let defaultValue: T
    
    private var fileUrl: URL {
        URL.tmpUrl(file: filename.urlEncoded())
    }
    
    public init(filename: String, defaultValue: T) {
        self.filename = filename
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            guard let data = try? Data(contentsOf: fileUrl),
                let decodedValue = try? JSONDecoder().decode(T.self, from: data) else {
                    return defaultValue
            }
            return decodedValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                try data.write(to: fileUrl, options: .atomicWrite)
            } catch {
                return print("Failed persisting \(newValue): error: \(error)")
            }
        }
    }
}



private extension String {
    func urlEncoded() -> String {
        return replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
    }
}

private extension URL {
    static func tmpUrl(file: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory().appending(file))
    }
}
