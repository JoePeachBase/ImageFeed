import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
