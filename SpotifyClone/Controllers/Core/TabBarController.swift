import UIKit

class TabBarController: UITabBarController {

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    // MARK: - Helper Functions -
    
    private func configureTabBar() {
        /// the controllers for this tab bar controller
        let vc1 = HomeController()
        let vc2 = SearchController()
        let vc3 = LibraryController()
        
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
        
        let initialControllersArray = [vc1, vc2, vc3]
        
        initialControllersArray.forEach { vc in
            /// configure the large title for each controller
            vc.navigationItem.largeTitleDisplayMode = .always
        }
    
        /// put each controller in a navigation controller
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)

        [nav1, nav2, nav3].forEach { nav in
            /// the tint color for each navigation controller
            nav.navigationBar.tintColor = Constants.mainColor
            
            /// set the title text of the nav bar of each nav
            nav.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : Constants.mainColor!
            ]
            
            /// configure the large title for each controller
            nav.navigationBar.prefersLargeTitles = true
        }
        
        /// the title and the image for bottom of the tab bar controller
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        /// assing the controller for the tab bar
        setViewControllers([nav1, nav2, nav3], animated: false)
        
        /// configure the color of the tab bar
        UITabBar.appearance().tintColor = Constants.mainColor
        UITabBar.appearance().isTranslucent = true
    }

}
