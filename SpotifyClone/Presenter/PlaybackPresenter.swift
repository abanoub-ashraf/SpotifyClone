import Foundation
import UIKit
import AVFoundation

///
/// Summary of playing and controlling the music:
/// ===============================================
///
///     1- when i click on a single track or an array of tracks
///
///     2- the presenter will call the startPlayback() functions with the track/tracks array i clicked on
///
///     3- now the track/tracks are stored inside the track/tracks variables inside the presenter
///
///     4- the currentItem variable inside the presenter will have the data of the single track or the first track
///        of the tracks array and send the data to the player controller through the PlayerDataSource
///
///     5- if i clicked on any controls button like the forward one, it will trigger the delegate function inside
///        the controls view file to go to the enxt track inside the player but that happens in the presenter
///        so another delegate function will get triggered from the player controller to do something in the
///        presenter which is going to the next track because the presenter holds the tracks and plays them,
///        not the player controller
///


///
/// 1- a delegate between the controls view and the player controller
///
///     - to make changes inside the player controller when the buttons in the controls view are tapped
///       like tapping on the play buton in the controls view to change its image inside the player
///       controller into pause image and also to pause the music itself but this needs another delegate between
///       the player controller and the presenter who actually playing the audio
///
/// 2- a delegate between the player controller and the presenter
///
///     - to control the playing music inside the presenter but from within the player controller
///       like pause the playing audio by clicking on the button from the controls view of the player
///       and pause the music from the presenter cause it's the one who plays the audio
///
/// 3- a data source between the presenter and the player controller
///
///     - to pass the current playing track's data from the presenter to the player controller
///       cause the player will display those data like the name of the song etc
///

// MARK: - PlayerDataSource

///
/// - this datasource will send the tracks info from the presenter to the player controller
///
/// - the datasource proeprty is gonna be in the player controller
///
protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    // MARK: - Properties
    
    static let shared = PlaybackPresenter()
    ///
    /// to hold the track when it's given to this presenter
    ///
    private var track: AudioTrackModel?
    ///
    /// to hold the tracks after they're given to this presenter
    ///
    private var tracks = [AudioTrackModel]()
    ///
    /// - keeps track of the current playing audio track
    ///
    /// - gives the current track data to the data source
    ///   which will pass it to the player controller
    ///
    var currentTrack: AudioTrackModel? {
        ///
        /// - if there's a single and the tracks list is empty
        ///   return that single track
        ///
        /// - if the tracks list is not empty
        ///   return its first one
        ///
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        
        return nil
    }
    
    var player: AVPlayer?
    
    var playerQueue: AVQueuePlayer?
    
    ///
    /// to call its refreshUI method to configure the UI of it with the new song
    ///
    var playerVC: PlayerController?
    
    ///
    /// track thr current song in the array of tracks
    ///
    var index = 0
    
    // MARK: - Helper Functions
    
    ///
    /// this functions gets called from the places where a single track is tapped
    /// in order for it to be presented in a player controller
    ///
    func startPlayback(from viewController: UIViewController, track: AudioTrackModel) {
        let vc = PlayerController()
        vc.title = track.name
        
        guard let url = URL(string: track.preview_url ?? "") else { return }
        
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        
        ///
        /// assign this file to be the data source for the player controller
        /// this file will give the track info to the player controller
        ///
        vc.playerDataSource = self
        ///
        /// this delegate will take the actions from the player and apply them on the presenter
        /// like control the music
        ///
        vc.playerControllerDelegate = self
        
        ///
        /// - the view controller that will be given to this function
        ///   will present the player in a navigation controller
        ///
        /// - start playing once the player controller is presented on the screen
        ///
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            if self?.playerQueue?.timeControlStatus == .playing {
                self?.playerQueue?.pause()
                self?.playerQueue = nil
            }
            if self?.player?.timeControlStatus == .playing {
                self?.player?.pause()
            }
            self?.player?.automaticallyWaitsToMinimizeStalling = false
            self?.player?.play()
        }
        
        ///
        /// so we can use the refreshUI functions of it and its controls button as well
        ///
        self.playerVC = vc
    }
    
    ///
    /// this function get called from the places where the play button is tapped
    /// to present a player with an array of tracks (playlist/album)
    ///
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrackModel]) {
        self.index = 0
        
        let vc = PlayerController()
        
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else { return nil }
            return AVPlayerItem(url: url)
        })
        
//        self.playerQueue = nil
        self.playerQueue = AVQueuePlayer(items: items)
        self.player?.pause()
        self.player = nil
        
        self.playerQueue?.volume = 0.5
        
        vc.playerDataSource = self
        vc.playerControllerDelegate = self
        
        ///
        /// the view controller that will be given to this function
        /// will present the player in a navigation controller
        ///
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            if self?.player?.timeControlStatus == .playing {
                self?.player?.pause()
                self?.player = nil
            }
            if self?.playerQueue?.timeControlStatus == .playing {
                self?.playerQueue?.pause()
            }
            self?.playerQueue?.automaticallyWaitsToMinimizeStalling = false
            self?.playerQueue?.play()
        }
        
        ///
        /// so we can use the refreshUI functions of it and its controls button as well
        ///
        self.playerVC = vc
    }
    
    func playTrack(player: AVQueuePlayer) {
        if player.items().count > 0 {
            guard let trackURL = URL(string: tracks[index].preview_url ?? "") else { return }
            
            player.replaceCurrentItem(with: AVPlayerItem(url: trackURL))
            player.automaticallyWaitsToMinimizeStalling = false
            
            self.playerVC?.controlsView.playPauseButton.setImage(Constants.pauseImage, for: .normal)
            self.playerVC?.controlsView.isPlaying = true
            
            player.play()
        }
    }
    
}

// MARK: - PlayerDataSource

///
/// fill the properties of the data source protocol with the current track data
/// to give them to the player controller
///
extension PlaybackPresenter: PlayerDataSource {
    
    var songName: String? {
        if currentTrack == nil {
            return "Not Available"
        } else {
            return currentTrack?.name
        }
    }
    
    var subtitle: String? {
        if currentTrack == nil {
            return "Not Available"
        } else {
            return currentTrack?.artists.first?.name
        }
    }
    
    var imageURL: URL? {
        if currentTrack == nil {
            return URL(string: "https://user-images.githubusercontent.com/10991489/125995103-048f855f-a37b-4836-895e-06eba8493083.png")
        } else {
            return URL(string: currentTrack?.album?.images.first?.url ?? "")
        }
    }
    
}

// MARK: - PlayerControllerDelegate

///
/// this delegate make actions in the player and apply them in the presenter
/// like control the music
///
extension PlaybackPresenter: PlayerControllerDelegate {
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
            
            self.playerVC?.controlsView.playPauseButton.setImage(Constants.playImage, for: .normal)
            self.playerVC?.controlsView.isPlaying = false
        } else if let player = playerQueue {
            if index + 1 > tracks.count - 1 {
                index = 0
            } else {
                index += 1
            }
            ///
            /// refresh the ui of the player with the new audio track
            ///
            playerVC?.refreshUI()
            
            playTrack(player: player)
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            
            self.playerVC?.controlsView.playPauseButton.setImage(Constants.playImage, for: .normal)
            self.playerVC?.controlsView.isPlaying = false
        } else if let player = playerQueue {
            if index - 1 < 0 {
                index = tracks.count - 1
            } else {
                index -= 1
            }
            
            playerVC?.refreshUI()
            
            playTrack(player: player)
        }
    }
    
    func didSlideSlider(_ value: Float) {
        if player != nil {
            player?.volume = value
        } else if playerQueue != nil {
            playerQueue?.volume = value
        }
    }
    
}
