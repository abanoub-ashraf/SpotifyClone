import Foundation
import UIKit
import MBProgressHUD

func createAlert(title: String, message: String, viewController: UIViewController) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.view.tintColor = Constants.mainColor
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
