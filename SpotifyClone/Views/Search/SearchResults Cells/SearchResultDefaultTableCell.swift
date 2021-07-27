import UIKit
import SDWebImage

class SearchResultDefaultTableCell: UITableViewCell {
    
    // MARK: - Variables

    static let identifier = Constants.searchResultDefaultTableCell
    
    // MARK: - UI
    
    private let label: UILabel = {
        let label = UILabel()
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
        
        label.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
    }
    
    // MARK: - Helper Functions
    
    func configure(with viewModel: SearchResultDefaultTableCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(
            with: viewModel.imageUrl,
            placeholderImage: Constants.personPlaceholderImage,
            completed: nil
        )
    }

}
