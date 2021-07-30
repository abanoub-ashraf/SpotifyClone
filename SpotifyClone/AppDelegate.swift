import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /** configure the window in code instead of storyboard */
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // if the user is logged in go to the tab bar, else, go to the welcome screen
        if AuthManager.shared.isSignedIn {
            /// as soon as the app launches it will refresh the token if needed
            AuthManager.shared.refreshIfNeeded(completion: nil)
            
            window.rootViewController = TabBarController()
        } else {
            let navVC = UINavigationController(rootViewController: WelcomeController())
            
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            
            window.rootViewController = navVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
