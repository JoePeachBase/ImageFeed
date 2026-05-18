import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setName(_ name: String)
    func setLoginName(_ loginName: String)
    func setDescription(_ description: String)
    func setAvatarImage(_ image: UIImage?)
}

private enum AlertStrings {
    static let title = "Пока, пока!"
    static let message = "Уверены, что хотите выйти?"
    static let yesAction = "Да"
    static let noAction = "Нет"
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(hex: 0xFFFFFF)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(hex: 0xAEAFB4)
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = UIColor(hex: 0xFFFFFF)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(resource: .exitButton),
            target: self,
            action: #selector(logoutButtonDidTapped))
        button.tintColor = UIColor(hex: 0xF56B6C)
        button.accessibilityIdentifier = "logout button"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x1A1B22)
        setupLayout()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setLoginName(_ loginName: String) {
        loginNameLabel.text = loginName
    }
    
    func setDescription(_ description: String) {
        descriptionLabel.text = description
    }
    
    func setAvatarImage(_ image: UIImage?) {
        avatarImageView.image = image
    }
    
    @objc private func logoutButtonDidTapped() {
        let alert = UIAlertController(
            title: AlertStrings.title,
            message: AlertStrings.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Bye bye!"
        
        let yesAction = UIAlertAction(title: AlertStrings.yesAction, style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter?.clean()
            self.goToSplashViewController()
        }
        let noAction = UIAlertAction(title: AlertStrings.noAction, style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.actions.first?.accessibilityIdentifier = "Yes"
        present(alert, animated: true)
        
    }
    
    private func setupLayout() {
        let innerStackView = UIStackView()
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        innerStackView.addArrangedSubview(avatarImageView)
        innerStackView.addArrangedSubview(spacer)
        innerStackView.addArrangedSubview(logoutButton)
        
        mainStackView.addArrangedSubview(innerStackView)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(loginNameLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func goToSplashViewController() {
        let splashViewController = SplashViewController()
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        window.rootViewController = splashViewController
    }
}
