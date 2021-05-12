import UIKit

class WelcomeController: UIViewController {
    
    // MARK: - UI -
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // layout the sign in button
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    // MARK: - Helper Functions -
    
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
    
    // MARK: - Selectors -
    
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
