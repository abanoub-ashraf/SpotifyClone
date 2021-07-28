import Foundation
import UIKit

func createAlert(viewController: UIViewController) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: "Done!", message: "The song is added Successfully", preferredStyle: .alert)
        alert.view.tintColor = Constants.mainColor
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
