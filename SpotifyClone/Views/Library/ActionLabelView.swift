import UIKit

///
/// this is for when we click on the create playlist button inside the action label view
/// we wanna create a new playlist, it will get created inside the child playlists controller
/// in the library controller and also will be added in there
///
protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

///
/// - this view will be shown inside the child playlists controller in the library controller
///   only if the current user doesn't have any playlists
///
/// - it contains a label to let the user know there's no playlists to be displayed and a button
///   to create a new playlist
///
class ActionLabelView: UIView {
    
    // MARK: - Properties

    weak var actionLabelViewDelegate: ActionLabelViewDelegate?
    
    // MARK: - UI
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.mainColor?.cgColor
        button.setTitleColor(Constants.mainColor, for: .normal)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        isHidden = true
        
        addSubview(label)
        addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height - 45)
        
        button.frame = CGRect(x: 0, y: height - 60, width: width, height: 45)
    }
    
    // MARK: - Helper Functions

    func configure(with viewModel: ActionLabelViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    // MARK: - Selectors

    @objc private func didTapButton() {
        ///
        /// once this function is called, inside the child playlists controller there will be a creation
        /// of a new playlist and will be added there as well
        ///
        actionLabelViewDelegate?.actionLabelViewDidTapButton(self)
    }
    
}
