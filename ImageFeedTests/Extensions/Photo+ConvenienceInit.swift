@testable import ImageFeed
import Foundation

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
