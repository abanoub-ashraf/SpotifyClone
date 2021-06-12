import UIKit
import SDWebImage

class PlayerController: UIViewController {
    
    // MARK: - Properties -

    ///
    /// the property of the data source protocol
    ///
    weak var dataSource: PlayerDataSource?

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
        
        controlsView.delegate = self
        
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
        // play a song
    }
    
    func playerControlsViewDidTapForwardButton(_ playControlsView: PlayerControlsView) {
        // forward
    }
    
    func playerControlsViewDidTapBackwardButton(_ playControlsView: PlayerControlsView) {
        // backward
    }
    
}
