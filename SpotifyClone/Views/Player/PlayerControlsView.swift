import Foundation
import UIKit

// MARK: - PlayerControlsViewDelegate

///
/// when i click on any of the controls buttons inside the player controls view
/// i want that click to do something inside the player controller
///
protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDelegateDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegateDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegateDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDelegateDidSlideVolume(_ playerControlsView: PlayerControlsView, value: Float)
}

// MARK: - PlayerControlsView

final class PlayerControlsView: UIView {
    
    // MARK: - Properties

    weak var controlsViewDelegate: PlayerControlsViewDelegate?
    
    var isPlaying = true
        
    // MARK: - UI

    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This Is My Song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake (feat. Some Other Artist)"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    var playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle

    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: 50
        )
        
        subtitleLabel.frame = CGRect(
            x: 0,
            y: nameLabel.bottom + 10,
            width: width,
            height: 50
        )
        
        volumeSlider.frame = CGRect(
            x: 10,
            y: subtitleLabel.bottom + 20,
            width: width - 20,
            height: 44
        )
        
        let buttonSize: CGFloat = 60
        
        playPauseButton.frame = CGRect(
            x: (width - buttonSize) / 2,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize
        )
        
        backButton.frame = CGRect(
            x: playPauseButton.left - 80 - buttonSize,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
        
        nextButton.frame = CGRect(
            x: playPauseButton.right + 80,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize
        )
    }
    
    // MARK: - Helper Functions

    ///
    /// configure the ui of this controls view with the view model
    /// that is given to it from the player controller
    ///
    func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
        
    // MARK: - Selectors
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        controlsViewDelegate?.playerControlsViewDelegateDidSlideVolume(self, value: slider.value)
    }

    @objc private func didTapBack() {
        ///
        /// - this is one of the PlayerControlsViewDelegate Protocol functions
        ///
        /// - when this selector function is tapped, we want the player controller
        ///   to go to the previous track
        ///
        controlsViewDelegate?.playerControlsViewDelegateDidTapBackwardButton(self)
    }
    
    @objc private func didTapNext() {
        ///
        /// - this is one of the PlayerControlsViewDelegate Protocol functions
        ///
        /// - when this selector function is tapped, we want the player controller
        ///   to go to the next track
        ///
        controlsViewDelegate?.playerControlsViewDelegateDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause() {
        ///
        /// this variable for togling the image of the play button every time it's tapped
        ///
        self.isPlaying = !isPlaying
        ///
        /// - this is one of the PlayerControlsViewDelegate Protocol functions
        ///
        /// - when this selector function is tapped, we want the player controller
        ///   to go to the play/pause the current track that's being played
        ///
        controlsViewDelegate?.playerControlsViewDelegateDidTapPlayPauseButton(self)
        ///
        /// update the image of this button every time it's tapped
        ///
        playPauseButton.setImage(isPlaying ? Constants.pauseImage : Constants.playImage, for: .normal)
    }
    
}
