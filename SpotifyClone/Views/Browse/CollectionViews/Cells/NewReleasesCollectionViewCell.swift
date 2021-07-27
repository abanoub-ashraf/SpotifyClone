import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier = Constants.newReleasesCollectionViewCellIdentifier
    
    // MARK: - UI
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        
        contentView.setRoundedColoredBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 10
        
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10,
                height: contentView.height - 10
            )
        )
        
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumCoverImageView.layer.cornerRadius = 10
        albumCoverImageView.clipsToBounds = true
        
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            // to line break the album name into multiple lines
            width: albumLabelSize.width,
            height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right - 10,
            height: 30
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.bottom - 44,
            // because we set sizeToFit() for taht label
            width: numberOfTracksLabel.width,
            height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text       = nil
        artistNameLabel.text      = nil
        numberOfTracksLabel.text  = nil
        albumCoverImageView.image = nil
    }
    
    // MARK: - Helper Functions
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text      = viewModel.name
        artistNameLabel.text     = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        
        albumCoverImageView.sd_setImage(
            with: viewModel.artWorkURL,
            placeholderImage: Constants.albumCoverPlaceholder,
            completed: nil
        )
    }
    
}
