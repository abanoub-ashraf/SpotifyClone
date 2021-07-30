import UIKit
import Foundation

extension UIImageView {
    
    ///
    /// to set rounded corners with colored borders
    ///
    func setRoundedBorder(radiusFloatPoints: CGFloat?, borderWidthPoints: CGFloat, borderColor: CGColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radiusFloatPoints ?? CGFloat()
        self.layer.borderWidth = borderWidthPoints
        self.layer.borderColor = borderColor
    }
    
}

extension Notification.Name {
    
    static let albumSavedNotification = Notification.Name(Constants.albumSavedNotification)
    
    static let trackAddedToOrDeletedFromPlaylistNotification = Notification.Name(Constants.trackAddedToOrDeletedFromPlaylistNotification)
    
}
