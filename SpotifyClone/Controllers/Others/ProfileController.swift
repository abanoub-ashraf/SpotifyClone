import UIKit
import SDWebImage
import MBProgressHUD

class ProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    
    private var models = [String]()
    
    // MARK: - UI
    
    // tableview to display the user data
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        fetchProfile()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Helper Functions
    
    // fetch the current logged in user profile
    private func fetchProfile() {
        models.removeAll()
        tableView.reloadData()
        
        MBProgressHUD.showAdded(to: self.view ?? UIView(), animated: true)

        NetworkManager.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let model):
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
        tableView.isHidden = false
        tableView.separatorStyle = .none
        
        models.append("Full Name: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        models.append("Country: \(model.country)")
        models.append("Product: \(model.product)")
        models.append("Type: \(model.type)")
        models.append("Followers: \(model.followers.total ?? 0)")
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    // a header for the table view that contains the image of the user profile
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        
        let imageSize: CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        headerView.addSubview(imageView)
        
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, placeholderImage: Constants.Images.personPlaceholderImage)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Constants.mainColor?.cgColor
        
        tableView.tableHeaderView = headerView
    }
    
    // in case we failed at fetching the current profile data
    private func failedToGetProfile() {
        tableView.isHidden = false
        
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
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
