import UIKit

class TitleHeader: UICollectionReusableView {
    
    // MARK: - Variables -
    
    static let identifier = Constants.titleCollectionViewHeaderIdentifier
    
    // MARK: - UI -
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    // MARK: - Helper Functions -
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}
