import UIKit
import AVFoundation

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
/// also responsible for playing the audio track after presenting the player
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
    /// to be able to play the audio track
    ///
    var player: AVPlayer?
    
    ///
    /// for the single track
    ///
    func startPlyback(from viewController: UIViewController, track: AudioTrackModel) {
        ///
        /// unwrap the preview url of the audio file we gonna play
        ///
        /// set the volume for the player
        ///
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
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
        
        ///
        /// so the player can commit changes on the audio track
        /// that is inside the presenter
        ///
        vc.playerControllerDelegate = self
        
        ///
        /// start playing after presenting the player on the screen
        ///
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
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

// MARK: - PlayerControllerDelegate -

///
/// this delegate responsible for playing the tracks
/// when the controls inside the controls view are clicked
/// they fire the controls delegate methods inside the player controller
/// which also fires the player controller delgate methods to handle the playing of the tracks
///
extension PlaybackPresenter: PlayerControllerDelegate {
    
    ///
    /// pause the player if it was playing
    /// and play it if it was paused
    ///
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    ///
    /// if there's no tracks then this is not a playlist or an album
    /// just pause the current playing track
    ///
    /// if there's tracks then go to the next track
    ///
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else {
            //
        }
    }
    
    ///
    /// if there's no tracks then this is not a playlist or an album
    /// just pause the current playing track then play it again
    ///
    /// if there's tracks then go to the previous track
    ///
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else {
            //
        }
    }
    
    ///
    /// update the volume of the player with the value of the slider
    ///
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }

}
