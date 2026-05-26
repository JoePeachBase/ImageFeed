@testable import ImageFeed
import Foundation

// MARK: - ImagesListPresenterSpy
 
final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    var photosCountToReturn = 0
    var stubPhotos: [Photo] = []
    var largeImageURLToReturn: URL?
    var fetchPhotosNextPageCalled = false
    var fetchPhotosNextPageCallCount = 0
    var setLikeCalled = false
    var setLikePhotoId: String?
    var setLikeIsLike: Bool?
    var setLikeCompletionResult: Result<Void, Error>?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photosCount() -> Int {
        photosCountToReturn
    }
    
    func photo(at index: Int) -> ImageFeed.Photo {
        guard index < stubPhotos.count else {
            fatalError("Spy: index out of range in photo(at:)")
        }
        return stubPhotos[index]
    }
    
    func largeImageURL(at index: Int) -> URL? {
        largeImageURLToReturn
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        fetchPhotosNextPageCallCount += 1
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        setLikeCalled = true
        setLikePhotoId = photoId
        setLikeIsLike = isLike
        if let result = setLikeCompletionResult {
            completion(result)
        }
    }
}
