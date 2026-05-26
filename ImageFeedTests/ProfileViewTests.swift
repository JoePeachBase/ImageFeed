@testable import ImageFeed
import UIKit
import XCTest

final class ProfileTest: XCTestCase {
    
    // MARK: - Properties
    
    private var viewController: ProfileViewController!
    private var presenterSpy: ProfilePresenterSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        viewController = ProfileViewController()
        presenterSpy = ProfilePresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        
        super.tearDown()
    }
    
    func testViewControllerCallsViewDidLoad(){
        // Given
//        let viewController = ProfileViewController()
//        let presenter = ProfilePresenterSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // Given
//        let viewController = ProfileViewController()
//        let presenter = ProfilePresenterSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController

        // When
        presenterSpy.updateAvatar()

        //Then
        XCTAssertTrue(presenterSpy.update)
    }
    
    func testPresenterCallsCleanServices() {
        // Given
//        let viewController = ProfileViewController()
//        let presenter = ProfilePresenterSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController

        // When
        presenterSpy.clean()

        // Then
        XCTAssertTrue(presenterSpy.cleanServices)
    }
    
    func testViewControllerCallsSetName() {
        // Given
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        
        // When
        view.setName("Ekaterina Novikova")

        // Then
        XCTAssertTrue(view.setName)
    }

    func testViewControllerCallsSetLoginName() {
        // Given
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        
        // When
        view.setLoginName("ekaterina_nov")

        // Then
        XCTAssertTrue(view.setLoginName)
    }

    func testViewControllerCallsSetDescription() {
        // Given
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        
        // When
        view.setDescription("Description")

        // Then
        XCTAssertTrue(view.setDescription)
    }

    func testViewControllerCallsSetAvatarImage() {
        // Given
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy(presenter: presenter)
        
        // When
        view.setAvatarImage(UIImage(named: "avatarImage"))

        // Then
        XCTAssertTrue(view.setAvatarImage)
    }
}
