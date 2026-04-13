import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let bearerToken = "Bearer_token"
    
    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: bearerToken)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: bearerToken)
            } else {
                KeychainWrapper.standard.removeObject(forKey: bearerToken)
            }
        }
    }
}
