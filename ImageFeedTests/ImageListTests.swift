@testable import ImageFeed
import UIKit
import XCTest

final class ImagesListTests: XCTestCase {
    
    // MARK: - Properties
    
    private var storyboard: UIStoryboard!
    private var viewController: ImagesListViewController!
    private var presenterSpy: ImagesListPresenterSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController
        
        presenterSpy = ImagesListPresenterSpy()
        
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
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableView() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        serviceMock.fetchPhotosNextPage()
        
        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsFetchPhotos() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(serviceMock.fetchPhotosNextPageCalled)
    }
    
    func testPhotosCountReturnsZeroInitially() {
        // Given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        
        // When
        
        // Then
        XCTAssertEqual(presenter.photosCount(), 0)
    }
    
    func testPhotoAtIndexReturnsCorrectPhoto() {
        // Given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        serviceMock.photos = [Photo(id: "test-42")]
        
        // When
        let photo = presenter.photo(at: 0)
        
        // Then
        XCTAssertEqual(photo.id, "test-42")
    }
    
    func testLargeImageURLReturnsValidURL() {
        // Given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        let expectedURL = URL(string: "https://example.com/large.jpg")
        serviceMock.photos = [Photo(id: "test-1", largeImageURL: "https://example.com/large.jpg")]
        
        // When
        let url = presenter.largeImageURL(at: 0)
        
        // Then
        XCTAssertEqual(url, expectedURL)
    }

    func testLargeImageURLReturnsNilForInvalidURL() {
        // Given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        serviceMock.photos = [Photo(id: "test-1", largeImageURL: "not-a-url")]
        
        // When
        let url = presenter.largeImageURL(at: 0)
        
        // Then
        XCTAssertNil(url)
    }

    func testSetLikeCallsServiceChangeLike() {
        // Given
        let serviceMock = ImagesListServiceMock()
        let presenter = ImagesListPresenter(imagesListService: serviceMock)
        let photoId = "photo-42"
        let isLike = true
        var completionCalled = false
        
        // When
        presenter.setLike(photoId: photoId, isLike: isLike) { result in
            if case .success = result {
                completionCalled = true
            }
        }
        
        serviceMock.changeLikeCompletion?(.success(()))
        
        // Then
        XCTAssertTrue(serviceMock.changeLikeCalled)
        XCTAssertTrue(completionCalled)
    }
}


