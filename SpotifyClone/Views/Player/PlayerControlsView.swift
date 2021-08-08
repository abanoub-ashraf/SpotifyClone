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
        slider.tintColor = Constants.mainColor
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This Is My Song"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Constants.mainColor
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake (feat. Some Other Artist)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = Constants.mainColor
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
        button.tintColor = Constants.mainColor
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
        button.tintColor = Constants.mainColor
        return button
    }()
    
    var playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        button.tintColor = Constants.mainColor
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let volumeLow: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(
            systemName: "speaker.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)
        )
        imageView.tintColor = Constants.mainColor
        imageView.image = image
        return imageView
    }()
    
    private let volumeHigh: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(
            systemName: "speaker.wave.3.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)
        )
        imageView.tintColor = Constants.mainColor
        imageView.image = image
        return imageView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helper Functions
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        addSubview(volumeLow)
        addSubview(volumeHigh)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        
        clipsToBounds = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [
            nameLabel,
            subtitleLabel,
            volumeSlider,
            backButton,
            nextButton,
            playPauseButton,
            volumeLow,
            volumeHigh
        ].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 35),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            volumeLow.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            volumeLow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            volumeLow.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            volumeSlider.leadingAnchor.constraint(equalTo: volumeLow.trailingAnchor, constant: 16),
            volumeSlider.trailingAnchor.constraint(equalTo: volumeHigh.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            volumeHigh.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 36),
            volumeHigh.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            volumeHigh.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: volumeLow.bottomAnchor, constant: 44)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 44),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: volumeHigh.bottomAnchor, constant: 44),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

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
        playPauseButton.setImage(isPlaying ? Constants.Images.pauseImage : Constants.Images.playImage, for: .normal)
    }
    
}
