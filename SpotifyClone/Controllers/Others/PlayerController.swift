import UIKit
import SDWebImage

///
/// - first delegate between the controls view and the player
///   so when any button is tapped inside the controls
///   the player do something (play pause/forward/backward)
///
/// - but in order for that to happen the player controller ceed a way to communicate with the presenter who
///   actually play the track in order to tell it to play pause/forward/backward
///
/// - and this player controller delegate does that
///
protocol PlayerControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerController: UIViewController {
    
    // MARK: - Properties -

    ///
    /// the property of the data source protocol
    ///
    weak var dataSource: PlayerDataSource?
    
    ///
    /// so the player can commit changes on the audio track
    /// that is inside the presenter
    ///
    weak var playerControllerDelegate: PlayerControllerDelegate?

    // MARK: - UI -

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.albumCoverPlaceholder
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        controlsView.controlsDelegate = self
        
        configureBarButtons()
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15
        )
    }
    
    // MARK: - Helper Functions -
    
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
    /// configure the player controller
    /// with the data that the data source sent from the presenter
    /// to this player
    ///
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        
        controlsView.configure(
            with: PlayerControlsViewViewModel(
                title: dataSource?.songName, subtitle: dataSource?.subtitle
            )
        )
    }
    
    // MARK: - Selectors -
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // TODO: - Actions -
    }

}

// MARK: - PlayerControlsViewDelegate -

///
/// this is gonna have the action the player controller will do
/// when each button in the controls view is tapped
///
extension PlayerController: PlayerControlsViewDelegate {
    
    func playerControlsViewDidTapPlayPauseButton(_ playControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playControlsView: PlayerControlsView) {
        playerControllerDelegate?.didTapBackward()
    }
    
    func playerControlsViewVolumeSlider(_ playControlsView: PlayerControlsView, didSlideSlider value: Float) {
        playerControllerDelegate?.didSlideSlider(value)
    }
    
}
