import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func clean()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        observeAvatarChanges()
    }
    
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let imageUrl = URL(string: profileImageURL) else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        let placeholderImage = UIImage(resource: .avatarPlaceholder)
        
        KingfisherManager.shared.retrieveImage(
            with: imageUrl,
            options: [.processor(processor),
                      .forceRefresh,
                      .scaleFactor(UIScreen.main.scale),
                      .cacheOriginalImage]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    self.view?.setAvatarImage(value.image)
                case .failure:
                    self.view?.setAvatarImage(placeholderImage)
                }
            }
    }
    
    func clean() {
        ProfileLogoutService.shared.logout()
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        view?.setName(profile.name)
        view?.setLoginName(profile.loginName)
        if let bio = profile.bio, !bio.isEmpty {
            view?.setDescription(bio)
        } else {
            view?.setDescription("Профиль не заполнен")
        }
    }
    
    private func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
}
