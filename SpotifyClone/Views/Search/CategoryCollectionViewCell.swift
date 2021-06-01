import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables -
    
    static let identifier = Constants.CategoryCollectionViewCellIdentifier
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]
    
    // MARK: - UI -
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        )
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.setRoundedColoredBorders()
        
        label.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 20,
            height: contentView.height / 2
        )
        
        imageView.frame = CGRect(
            x: (contentView.width / 2) - 10,
            y: 10,
            width: contentView.width / 2,
            height: contentView.height / 2
        )
        
        imageView.setRoundedBorder(
            radiusFloatPoints: 10,
            borderWidthPoints: 1,
            borderColor: UIColor.systemGray.cgColor
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        )
    }
    
    // MARK: - Helper Functions -
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
