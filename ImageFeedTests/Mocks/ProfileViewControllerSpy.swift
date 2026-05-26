@testable import ImageFeed
import UIKit

// MARK: - ProfileViewControllerSpy

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    var setName = false
    var setLoginName = false
    var setDescription = false
    var setAvatarImage = false
    
    func setName(_ name: String) {
        setName = true
    }
    
    func setLoginName(_ loginName: String) {
        setLoginName = true
    }
    
    func setDescription(_ description: String) {
        setDescription = true
    }
    
    func setAvatarImage(_ image: UIImage?) {
        setAvatarImage = true
    }
}
