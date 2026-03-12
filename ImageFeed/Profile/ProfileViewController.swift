import UIKit

final class ProfileViewController: UIViewController {
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .avatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
    }
    
    @objc private func logoutButtonDidTapped() {
        print("logoutButtonDidTapped")
    }
    
    private func setupLayout() {
        let innerStackView = UIStackView()
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
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
