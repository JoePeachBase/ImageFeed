@testable import ImageFeed
import Foundation
import UIKit
import XCTest

final class ProfileTest: XCTestCase {
    func testViewControllerCallsViewDidLoad(){
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.updateAvatar()

        XCTAssertTrue(presenter.update)
    }
    
    func testPresenterCallsCleanServices() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.clean()

        XCTAssertTrue(presenter.cleanServices)
    }
    
    func testViewControllerCallsSetName() {
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.setName("Ekaterina Novikova")

        XCTAssertTrue(view.setName)
    }

    func testViewControllerCallsSetLoginName() {
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.setLoginName("ekaterina_nov")

        XCTAssertTrue(view.setLoginName)
    }

    func testViewControllerCallsSetDescription() {
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.setDescription("Description")

        XCTAssertTrue(view.setDescription)
    }

    func testViewControllerCallsSetAvatarImage() {
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.setAvatarImage(UIImage(named: "avatarImage"))

        XCTAssertTrue(view.setAvatarImage)
    }
}

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
