import UIKit

class RecommendedTracksCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables -

    static let identifier = Constants.recommendedTracksCollectionViewCellIdentifier
    
    // MARK: - UI -
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.newReleasesPlaceholderImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.setRoundedColoredBorders()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 4,
            width: contentView.height - 8,
            height: contentView.height - 8
        )
        
        albumCoverImageView.setRoundedBorder(
            radiusFloatPoints: nil,
            borderWidthPoints: 0.5,
            borderColor: UIColor.systemGray.cgColor
        )
        
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 0,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.height / 2,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text       = nil
        artistNameLabel.text      = nil
        albumCoverImageView.image = nil
    }
    
    // MARK: - Helper Functions -
    
    func configure(with viewModel: RecommendedTracksCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        
        albumCoverImageView.sd_setImage(
            with: viewModel.artworkURL,
            placeholderImage: Constants.newReleasesPlaceholderImage,
            completed: nil
        )
    }
    
}
