import UIKit
import SDWebImage

class SearchResultSubtitleTableCell: UITableViewCell {
    
    // MARK: - Variables

    static let identifier = Constants.searchResultSubtitleTableCell
    
    // MARK: - UI
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 10
                
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        
        iconImageView.setRoundedBorder(
            radiusFloatPoints: imageSize / 2,
            borderWidthPoints: 0.8,
            borderColor: UIColor.systemGray.cgColor
        )
        
        let labelHeight = contentView.height / 2
        
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight
        )
        
        subtitleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.bottom,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
    
    // MARK: - Helper Functions
    
    func configure(with viewModel: SearchResultSubtitleTableCellViewModel) {
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(
            with: viewModel.imageUrl,
            placeholderImage: Constants.Images.albumCoverPlaceholder,
            completed: nil
        )
    }

}
