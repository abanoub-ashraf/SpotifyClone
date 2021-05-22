import UIKit
import SDWebImage

final class PlaylistHeader: UICollectionReusableView {
    
    // MARK: - Variables -
    
    static let identifier = Constants.playlistCollectionViewHeaderIdentifier
    
    // MARK: - UI -
    
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
        imageView.image = Constants.personPlaceholderImage
        return imageView
    }()
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        
        animateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -
    
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
        
    }
    
    // MARK: - Helper Functions -
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text        = viewModel.name
        ownerLabel.text       = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        
        imageView.sd_setImage(
            with: viewModel.artworkURL,
            placeholderImage: Constants.personPlaceholderImage
        )
    }
    
    private func animateUI() {
        UIView.animate(withDuration: 2) {
            self.nameLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.ownerLabel.alpha = 1
            self.imageView.alpha = 1
        }
    }
    
}
