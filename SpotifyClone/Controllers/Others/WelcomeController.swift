import UIKit

class WelcomeController: UIViewController {
    
    // MARK: - UI
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemFill
        button.setTitle("Log In with Spotify", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.5
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.borderColor = Constants.mainColor?.cgColor
        return button
    }()
    
    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Constants.mainColor?.cgColor ?? UIColor(),
            UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = .zero
       return gradientLayer
    }()
    
    private let logo: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 38)
        let image = UIImageView(image: UIImage(systemName: "music.quarternote.3", withConfiguration: config))
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go"
        return label
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        
        view.backgroundColor = .systemBackground
        
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(logo)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        
        // layout the sign in button
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
        
        logo.frame = CGRect(
            x: (view.width - 120) / 2,
            y: (view.height - 350) / 2,
            width: 120,
            height: 120
        )
        
        label.frame = CGRect(
            x: 30,
            y: logo.bottom + 30,
            width: view.width - 60,
            height: 150
        )
    }
    
    // MARK: - Helper Functions
    
    // if we are signed in go to the tab bar controller, if not, show an alert
    private func handleSignIn(success: Bool) {
        guard success else {
            // show an alert if the value we got from the completion handler is false
            let alert = UIAlertController(
                title: "Oops",
                message: "Something went wrong while signing in.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        // if it's a success value then go to the main app tab bar controller
        let mainAppTabBarVC = TabBarController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
    // MARK: - Selectors
    
    /// go to the auth controller that represents the web view authentication page
    @objc func didTapSignIn() {
        let vc = AuthController()
        
        // handle the result of the sign in process
        // handle what returns from the completion handler after the login process is done
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                // use the result we got from the auth controller and handle it
                // that has to happen in the main thread
                self?.handleSignIn(success: success)
            }
        }
        
        // so the title of the nav bar gets smaller
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
