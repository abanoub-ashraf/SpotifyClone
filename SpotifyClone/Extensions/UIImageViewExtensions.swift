import UIKit

extension UIImageView {
    
    /// to set rounded corners with colored borders
    func setRoundedBorder(radiusFloatPoints: CGFloat?, borderWidthPoints: CGFloat, borderColor: CGColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radiusFloatPoints ?? CGFloat()
        self.layer.borderWidth = borderWidthPoints
        self.layer.borderColor = borderColor
    }
    
}
