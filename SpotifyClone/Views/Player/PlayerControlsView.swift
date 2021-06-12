import UIKit

// MARK: - PlayerControlsViewDelegate -

///
/// - to let this view communicate with the player controller when any of its buttons
///   is tapped from inside this view
/// - we wanna the player controller to do something based on each tap
///
protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    // MARK: - Properties -

    weak var delegate: PlayerControlsViewDelegate?
    
    // MARK: - UI -

    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This is My Song"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake (feat. Some Other Artist)"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - Init -

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
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize: CGFloat = 60
        
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
    
    // MARK: - Selectors -
    
    @objc func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardButton(self)
    }
    
    @objc func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc func didTapPlayPause() {
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
    
    // MARK: - Helper Functions -
    
    func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
}
