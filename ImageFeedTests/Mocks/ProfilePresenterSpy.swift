@testable import ImageFeed
import WebKit

// MARK: - ProfilePresenterSpy

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var update: Bool = false
    var cleanServices: Bool = false
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        update = true
    }
    
    func clean() {
        cleanServices = true
    }
}
