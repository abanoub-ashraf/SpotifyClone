import UIKit
import SDWebImage

/// notify the PlaylistController that this the button inside the PlaylistHeader is tapped
protocol PlaylistHeaderDelegate: AnyObject {
    /// the param is the view that is making the delegate call
    func playlistHeaderDidTapPlayAll(_ header: PlaylistHeader)
}

final class PlaylistHeader: UICollectionReusableView {
    
    // MARK: - Variables
    
    weak var delegate: PlaylistHeaderDelegate?
    
    static let identifier = Constants.playlistCollectionViewHeaderIdentifier
    
    // MARK: - UI
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFill
        imageView.image = Constants.Images.personPlaceholderImage
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.mainColor
        let image = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        )
        button.alpha = 0
        button.setImage(image, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.tintColor = .label
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        
        /// start playing all the list in queue, the protocol on top of this file is doing that
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        
        animateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        
        imageView.frame = CGRect(
            x: (width - imageSize) / 2,
            y: 15,
            width: imageSize,
            height: imageSize
        )
        
        imageView.setRoundedBorder(
            radiusFloatPoints: imageView.width / 2,
            borderWidthPoints: 2,
            borderColor: UIColor.systemGray.cgColor
        )
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: width - 20,
            height: 44
        )
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom,
            width: width - 20,
            height: 44
        )
        
        playAllButton.frame = CGRect(
            x: width - 80,
            y: height - 80,
            width: 60,
            height: 60
        )
        
    }
    
    // MARK: - Helper Functions
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text        = viewModel.name
        ownerLabel.text       = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        
        imageView.sd_setImage(
            with: viewModel.artworkURL,
            placeholderImage: Constants.Images.playlistsPlaceholderImage
        )
        
        imageView.layer.borderColor = Constants.mainColor?.cgColor
        imageView.layer.borderWidth = 1.0
    }
    
    private func animateUI() {
        UIView.animate(withDuration: 2) {
            self.nameLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.ownerLabel.alpha = 1
            self.imageView.alpha = 1
            self.playAllButton.alpha = 1
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapPlayAll() {
        /// call the protocol delegate function to play the list in queue
        delegate?.playlistHeaderDidTapPlayAll(self)
    }
    
}
