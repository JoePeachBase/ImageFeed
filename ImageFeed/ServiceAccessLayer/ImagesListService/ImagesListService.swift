import Foundation

class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage.shared

    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    private(set) var photos: [Photo] = []
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10") else {
            assertionFailure("Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        guard let token = storage.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(from: $0)}
                self.lastLoadedPage = nextPage
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                
            case .failure(let error):
                print("[ImagesListService]: Ошибка запроса: \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>)
    -> Void) {
        guard let request = makeChangeLikeRequest(id: photoId, isLike: isLike) else {
            print("[ProfileImageService]: bad URL")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let newPhoto = Photo(from: result.photo)
                    DispatchQueue.main.async {
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                }
                print("liked_by_user: \(result.photo.isLiked)")
            case .failure(let error):
                print("[changeLike]: Ошибка запроса: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func makeChangeLikeRequest(id: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string:"https://api.unsplash.com/photos/\(id)/like") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        
        guard let token = storage.token else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func reset() {
        photos = []
        lastLoadedPage = nil
    }
}
