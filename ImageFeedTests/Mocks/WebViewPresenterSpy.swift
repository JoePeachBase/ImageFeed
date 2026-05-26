@testable import ImageFeed
import WebKit

// MARK: - WebViewPresenterSpy

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        return nil
    }
}
