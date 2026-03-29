import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let bearerToken = "Bearer_token"
    
    private init() {}
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: bearerToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bearerToken)
        }
    }
}
