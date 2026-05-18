import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func photosCount() -> Int
    func photo(at index: Int) -> Photo
    func largeImageURL(at index: Int) -> URL?
    func fetchPhotosNextPage()
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self .imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        setupObservers()
        imagesListService.fetchPhotosNextPage()
    }
    
    func photosCount() -> Int {
        imagesListService.photos.count
    }
    
    func photo(at index: Int) -> Photo {
        imagesListService.photos[index]
    }
    
    func largeImageURL(at index: Int) -> URL? {
        guard let url = URL(string: imagesListService.photos[index].largeImageURL),
              let scheme = url.scheme,
              !scheme.isEmpty else { return nil }
        return url
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print("[imageListCellDidTapLike]: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.view?.updateTableViewAnimated()
        }
    }
}
