import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            makeImagesListViewController(),
            makeProfileViewController()
        ]
    }

    private func makeImagesListViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(
                withIdentifier: "ImagesListViewController") as? ImagesListViewController
        else {
            fatalError("Unable to instantiate ImagesListViewController from Main.storyboard")
        }
        imagesListViewController.presenter = ImagesListPresenter()
        return imagesListViewController
    }

    private func makeProfileViewController() -> UIViewController {
        let profileViewController = ProfileViewController()
        profileViewController.presenter = ProfilePresenter(view: profileViewController)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        return profileViewController
    }
}
