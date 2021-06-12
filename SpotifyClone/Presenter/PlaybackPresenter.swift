import UIKit

///
/// the data source that will pass the track/tracks data
/// from the presenter player to the player controller
///
protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

///
/// to present the player controller every time a song is tapped
/// or a playlist/album as well
///
final class PlaybackPresenter {
    
    // MARK: - Properties -

    static let shared = PlaybackPresenter()
    
    ///
    /// to keep track of the current track that's given to this file
    ///
    private var track: AudioTrackModel?
    
    ///
    /// to keep[ track of the tracks that're given to this file
    ///
    private var tracks = [AudioTrackModel]()
    
    ///
    /// the current track that this file is holding
    /// it's gonna be the track if there's a given one
    /// or the first track of the given ones if there were given ones
    ///
    var currentTrack: AudioTrackModel? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    ///
    /// for the single track
    ///
    func startPlyback(from viewController: UIViewController, track: AudioTrackModel) {
        ///
        /// hold the given track when its' passed to this file
        ///
        self.track = track
        self.tracks = []
        
        let vc = PlayerController()
        vc.title = track.name
        
        ///
        /// to be the source of the datasource protocol
        ///
        vc.dataSource = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    ///
    /// for an array of tracks (playlist/album)
    ///
    func startPlyback(from viewController: UIViewController, tracks: [AudioTrackModel]) {
        ///
        /// hold the given tracks when they are passed to this file
        ///
        self.tracks = tracks
        self.track = nil
        
        let vc = PlayerController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}

// MARK: - PlayerDataSource -

///
/// implement the properties of the data source protocol
/// to send their data to the player controller
///
extension PlaybackPresenter: PlayerDataSource {
    
    ///
    /// the data of the current track that's being played
    /// in the player controller
    ///
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
}
