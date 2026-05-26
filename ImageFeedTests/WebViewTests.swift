@testable import ImageFeed
import Foundation
import XCTest
import WebKit

final class WebViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private var storyboard: UIStoryboard!
    private var viewController: WebViewViewController!
    private var presenterSpy: WebViewPresenterSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewController = storyboard.instantiateViewController(
            withIdentifier: "WebViewViewController"
        ) as? WebViewViewController
        
        presenterSpy = WebViewPresenterSpy()
        
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
    }
    
    override func tearDown() {
        storyboard = nil
        viewController = nil
        presenterSpy = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled) //behaviour verification
    }
    
    func testPresenterCallsLoadRequest() {
        // Given
        let viewControllerSpy = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewControllerSpy.presenter = presenter
        presenter.view = viewControllerSpy
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewControllerSpy.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() throws {
        // Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // When
        let url = try XCTUnwrap(authHelper.authURL())
        let urlString = url.absoluteString
        
        // Then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // Given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        // When
        let code = authHelper.code(from: url)
        
        // Then
        XCTAssertEqual(code, "test code")
    }
}
