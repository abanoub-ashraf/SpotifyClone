import UIKit

/// use these new properties we made instead of using long things like (frame.size.width)
extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    func setRoundedColoredBorders() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
    
}
