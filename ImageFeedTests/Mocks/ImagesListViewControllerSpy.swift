@testable import ImageFeed

// MARK: - ImagesListViewControllerSpy

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
