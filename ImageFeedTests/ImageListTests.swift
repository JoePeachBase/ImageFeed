@testable import ImageFeed
import Foundation
import UIKit
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableView() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        serviceMock.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsFetchPhotos() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(serviceMock.fetchPhotosNextPageCalled)
    }
    
    func testPhotosCountReturnsZeroInitially() {
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        
        XCTAssertEqual(presenter.photosCount(), 0)
    }
    
    func testPhotoAtIndexReturnsCorrectPhoto() {
        // given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        serviceMock.photos = [Photo(id: "test-42")]
        
        // when
        let photo = presenter.photo(at: 0)
        
        // then
        XCTAssertEqual(photo.id, "test-42")
    }
    
    func testLargeImageURLReturnsValidURL() {
        // given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        let expectedURL = URL(string: "https://example.com/large.jpg")
        serviceMock.photos = [Photo(id: "test-1", largeImageURL: "https://example.com/large.jpg")]
        
        // when
        let url = presenter.largeImageURL(at: 0)
        
        // then
        XCTAssertEqual(url, expectedURL)
    }

    func testLargeImageURLReturnsNilForInvalidURL() {
        // given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        serviceMock.photos = [Photo(id: "test-1", largeImageURL: "not-a-url")]
        
        // when
        let url = presenter.largeImageURL(at: 0)
        
        // then
        XCTAssertNil(url)
    }

    func testSetLikeCallsServiceChangeLike() {
        // given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        let photoId = "photo-42"
        let isLike = true
        var completionCalled = false
        
        // when
        presenter.setLike(photoId: photoId, isLike: isLike) { result in
            if case .success = result {
                completionCalled = true
            }
        }
        
        serviceMock.changeLikeCompletion?(.success(()))
        
        // then
        XCTAssertTrue(serviceMock.changeLikeCalled)
        XCTAssertTrue(completionCalled)
    }
}

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

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}

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

extension Photo {
    init(id: String) {
        self.init(
            id: id,
            size: CGSize(width: 100, height: 200),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "https://example.com/thumb.jpg",
            largeImageURL: "https://example.com/large.jpg",
            isLiked: false
        )
    }
    
    init(id: String, largeImageURL: String) {
        self.init(
            id: id,
            size: CGSize(width: 100, height: 200),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "https://example.com/thumb.jpg",
            largeImageURL: largeImageURL,
            isLiked: false
        )
    }
}


