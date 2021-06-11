import UIKit

class PlayerController: UIViewController {

    // MARK: - UI -

    private let imageView: UIImageView = {
        let imageView = UIImageView()
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
