import UIKit

///
/// to present the player controller every time a song is tapped
/// or a playlist/album as well
///
final class PlaybackPresenter {
    
    ///
    /// for the single track
    ///
    static func startPlyback(from viewController: UIViewController, track: AudioTrackModel) {
        let vc = PlayerController()
        viewController.present(vc, animated: true, completion: nil)
    }
    
    ///
    /// for an array of tracks (playlist/album)
    ///
    static func startPlyback(from viewController: UIViewController, tracks: [AudioTrackModel]) {
        let vc = PlayerController()
        viewController.present(vc, animated: true, completion: nil)
    }
    
}
