import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    @IBOutlet private weak var authenticateButton: UIButton!
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let authService = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        authenticateButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showWebViewSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        guard let webViewViewController = segue.destination as? WebViewViewController else {
            assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
            return
        }
        
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(
            authHelper: authHelper
        )
        
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(hex: 0x1A1B22)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        authService.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure:
                showAlertWith(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    buttonTitle: "Ок") { [weak vc] in
                        vc?.navigationController?.popViewController(animated: true)
                    }
                break
            }
        }
    }
    
    private func showAlertWith(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: buttonTitle,
            style: .default) { _ in
                completion?()
            }
        
        alert.addAction(action)
        present(alert, animated: true)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.fetchOAuthToken(code: code) { result in
            completion(result)
        }
    }
}
