import Foundation
import UIKit

///
/// add some device movments for selections and adding/creating new things among the app
///
final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
    
}
