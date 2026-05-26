@testable import ImageFeed
import Foundation

// MARK: - ImagesListServiceMock

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    var changeLikeCompletion: ((Result<Void, Error>) -> Void)?
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        changeLikeCalled = true
        changeLikeCompletion = completion
    }
}
