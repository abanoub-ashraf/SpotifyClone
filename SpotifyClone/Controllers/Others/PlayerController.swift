import UIKit
import SDWebImage

///
/// - this controll is gonna have a PlayerControllerDelegate, a PlayerDataSource, and a PlayerControlsViewDelegate
///
/// - the PlayerDataSource is between the player controller and the presenter
///   to send the data of the current playing track from the presenter to the player
///
/// - the PlayerControlsViewDelegate is between the controls view and this player controller
///   so when any button in the controls view is tapped, this player gets affected
///
/// - the PlayerControllerDelegate is between the player controller and the presenter
///   to control the playing music in the presenter through the player
///

protocol PlayerControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerController: UIViewController {
    
    // MARK: - Properties

    ///
    /// for the PlayerDataSource that will pass data from the presenter to this controller
    ///
    weak var playerDataSource: PlayerDataSource?
    ///
    /// for the PlayerControllerDelegate that will control the playing music
    /// in the presenter through the player
    ///
    weak var playerControllerDelegate: PlayerControllerDelegate?
    
    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Constants.Images.albumCoverPlaceholderImage
        return imageView
    }()
    
     var controlsView = PlayerControlsView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        ///
        /// this is for the PlayerControlsViewDelegate Protocol which is responsible for
        /// connect the clicks on the controls buttons in the controls view
        /// and apply the effects of the clicks here inside this player controller
        ///
        controlsView.controlsViewDelegate = self
        
        configureBarButtons()
        
        ///
        /// configure the ui of this player with the track info
        /// we got from the presenter through the player data source
        ///
        configure()
        
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Constants.mainColor?.cgColor

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(
            x: 16,
            y: view.safeAreaInsets.top + 16,
            width: view.width - 32,
            height: view.width - 32
        )
        
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15
        )
    }
    
    // MARK: - Helper Functions

    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        )
    }
    
    ///
    /// configure the ui of this player controller with the track info
    /// we got from the presenter through the player data source
    ///
    private func configure() {
        ///
        /// set the iamge of this player to be the one of the current playing track
        /// that the presenter is playing and sent to this controller through the data source
        ///
        imageView.sd_setImage(with: playerDataSource?.imageURL, completed: nil)
        ///
        /// set the ui of the controls view with the current track data
        ///
        controlsView.configure(
            with: PlayerControlsViewViewModel(
                title: playerDataSource?.songName,
                subtitle: playerDataSource?.subtitle
            )
        )
    }
    
    ///
    /// call this function from inside the presenter to refresh the player controller
    /// with the new audio track
    ///
    func refreshUI() {
        configure()
    }
    
    // MARK: - Selectors

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // Actions
    }
    
}

// MARK: - PlayerControlsViewDelegate

///
/// - this is for the PlayerControlsViewDelegate Protocol which is responsible for
///   connect the clicks on the controls buttons in the controls view
///   and apply the effects of the clicks here inside this player controller
///
/// - implement the effects of the clicks on the controls inside the controls view
///
extension PlayerController: PlayerControlsViewDelegate {
    
    func playerControlsViewDelegateDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapPlayPause()
    }
    
    func playerControlsViewDelegateDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapForward()
    }
    
    func playerControlsViewDelegateDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapBackward()
    }
    
    ///
    /// this function will take the slider value from the controls view file to this player in here
    /// then send it to the presenter cause the volume control is in the presenter file
    ///
    func playerControlsViewDelegateDidSlideVolume(_ playerControlsView: PlayerControlsView, value: Float) {
        playerControllerDelegate?.didSlideSlider(value)
    }
    
}
