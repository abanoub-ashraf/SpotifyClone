import UIKit
import SDWebImage
import MBProgressHUD

class ProfileController: UIViewController {
    
    // MARK: - Variables
    
    private var models = [String]()
    
    private var model: UserProfileModel?
    
    // MARK: - UI
    
    private let profileImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = Constants.mainColor?.cgColor
        image.layer.cornerRadius = image.frame.size.height / 2
        image.clipsToBounds = true
        return image
    }()
    
    private let profileName: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = Constants.mainColor
        label.font = .systemFont(ofSize: 26)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let profileEmail: UILabel = {
        let label = UILabel()
        label.text = "User Email"
        label.font = .systemFont(ofSize: 24)
        label.textColor = Constants.mainColor
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let profileFollowers: UILabel = {
        let label = UILabel()
        label.text = "Followers: 0"
        label.font = .systemFont(ofSize: 22)
        label.textColor = Constants.mainColor
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let profileCountry: UILabel = {
        let label = UILabel()
        label.text = "Country:"
        label.font = .systemFont(ofSize: 22)
        label.textColor = Constants.mainColor
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        fetchProfile()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        [profileImage, profileName, profileEmail, profileFollowers, profileCountry].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        setupConstraints()

    }
    
    // MARK: - Helper Functions
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 200),
            profileImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            profileEmail.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 20),
            profileEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileEmail.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            profileFollowers.topAnchor.constraint(equalTo: profileEmail.bottomAnchor, constant: 20),
            profileFollowers.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileFollowers.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            profileCountry.topAnchor.constraint(equalTo: profileFollowers.bottomAnchor, constant: 20),
            profileCountry.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileCountry.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // fetch the current logged in user profile
    private func fetchProfile() {
        models.removeAll()
        
        MBProgressHUD.showAdded(to: self.view ?? UIView(), animated: true)

        NetworkManager.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let model):
                        self?.model = model
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        self?.updateUI(with: model)
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        print("Profile Error: \(error.localizedDescription)")
                        
                        self?.failedToGetProfile()
                }
            }
        }
    }
    
    // fill the ui with the user profile's data
    private func updateUI(with model: UserProfileModel) {
        profileImage.isHidden     = false
        profileName.isHidden      = false
        profileEmail.isHidden     = false
        profileFollowers.isHidden = false
        profileCountry.isHidden   = false
        
        profileImage.sd_setImage(
            with: URL(string: model.images.first?.url ?? ""),
            placeholderImage: Constants.Images.personPlaceholderImage
        )
        
        profileName.text = model.display_name
        
        profileEmail.text = model.email
        
        profileFollowers.text = "Followers: \(model.followers.total ?? 0)"
        
        profileCountry.text = "Country: \(model.country)"
    }

    ///
    /// in case we failed at fetching the current profile data
    ///
    private func failedToGetProfile() {
        profileImage.isHidden     = true
        profileName.isHidden      = true
        profileEmail.isHidden     = true
        profileFollowers.isHidden = true
        profileCountry.isHidden   = true
        
        let label = UILabel(frame: .zero)
        
        label.text = "Failed to load your Profile! \nPlease check your Internet Connection"
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = Constants.mainColor
        label.textAlignment = .center
        
        view.addSubview(label)
        
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        label.center = view.center
    }
    
    // MARK: - Selectors

    @objc private func didTapShare() {
        guard let url = URL(string: model?.external_urls["spotify"] ?? "") else { return }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        
        vc.view.backgroundColor = Constants.mainColor
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true) {
            UINavigationBar.appearance().tintColor = Constants.mainColor
        }
    }
    
}
