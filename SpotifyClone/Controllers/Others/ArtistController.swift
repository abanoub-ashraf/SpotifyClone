import UIKit
import SDWebImage
import MBProgressHUD

class ArtistController: UIViewController {
    
    // MARK: - Properties

    private let artist: ArtistModel
    
    private var data: ArtistModel?
    
    private var artistAlbums: [AlbumModel]?
    
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
        label.text = "Your Name"
        label.textColor = Constants.mainColor
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private let profileFollowers: UILabel = {
        let label = UILabel()
        label.text = "Followers \n0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private let profilePopularity: UILabel = {
        let label = UILabel()
        label.text = "Popularity \n0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private let profileType: UILabel = {
        let label = UILabel()
        label.text = "Type \n-"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let tableHeader: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = Constants.mainColor
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load! \nPlease check your Internet Connection"
        label.sizeToFit()
        label.isHidden = true
        label.numberOfLines = 0
        label.textColor = Constants.mainColor
        label.textAlignment = .center
        return label
    }()
    
    private let errorButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Click to Refresh", for: .normal)
        button.isHidden = true
        button.setTitleColor(Constants.mainColor, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.mainColor?.cgColor
        button.addTarget(self, action: #selector(clickRefresh), for: .touchUpInside)
        return button
    }()
            
    // MARK: - Init

    init(artist: ArtistModel) {
        self.artist = artist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        fetchArtistDetails()
    }
    
    // MARK: - Helper Functions
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    
        [
            profileImage,
            profileName,
            profileFollowers,
            profilePopularity,
            profileType,
            tableView,
            tableHeader,
            errorLabel,
            errorButton
        ].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SearchResultSubtitleTableCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableCell.identifier
        )
                
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 200),
            profileImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            profileFollowers.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 10),
            profileFollowers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileFollowers.centerYAnchor.constraint(equalTo: profilePopularity.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profilePopularity.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 10),
            profilePopularity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileType.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 10),
            profileType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileType.centerYAnchor.constraint(equalTo: profilePopularity.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableHeader.topAnchor.constraint(equalTo: profileFollowers.bottomAnchor, constant: 8),
            tableHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableHeader.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalToConstant: 300),
            errorLabel.heightAnchor.constraint(equalToConstant: 300),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    
        NSLayoutConstraint.activate([
            errorButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            errorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func fetchArtistDetails() {
        MBProgressHUD.showAdded(to: self.view ?? UIView(), animated: true)

        NetworkManager.shared.getArtistDetails(for: artist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let artistData):
                        self?.data = artistData
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        self?.fetchArtistAlbums(artist: artistData)
                        
                        self?.updateUI(with: artistData)
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        print(error)
                        
                        self?.failedToGetArtist()
                }
            }
        }
    }
    
    private func fetchArtistAlbums(artist: ArtistModel) {
        NetworkManager.shared.getArtistAlbums(for: artist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.artistAlbums = albums
                    
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    ///
    /// in case we failed at fetching the artist data
    ///
    private func failedToGetArtist() {
        [
            profileImage,
            profileName,
            profileFollowers,
            profilePopularity,
            profileType,
            tableView,
            tableHeader
        ].forEach { subView in
            subView.isHidden = true
            subView.removeFromSuperview()
        }
    
        [errorLabel, errorButton].forEach({ subView in
            subView.isHidden = false
        })
    }

    private func updateUI(with artist: ArtistModel) {
        [
            profileImage,
            profileName,
            profileFollowers,
            profilePopularity,
            tableView,
            tableHeader,
            profileType
        ].forEach { subView in
            subView.isHidden = false
            view.addSubview(subView)
        }
        
        setupConstraints()
        
        [errorLabel, errorButton].forEach { (subView) in
            subView.isHidden = true
        }
        
        profileImage.sd_setImage(
            with: URL(string: artist.images?.first?.url ?? ""),
            placeholderImage: Constants.Images.personPlaceholderImage
        )
        
        profileName.text = artist.name
        
        profileFollowers.text = "Followers \n\(artist.followers?.total ?? 0)"
        
        profilePopularity.text = "Popularity \n\(artist.popularity ?? 0)"
        
        if artist.type == "artist" {
            profileType.text = "Type \nArtist"
        } else {
            profileType.text = "Type \n\(artist.type)"
        }
        
        tableHeader.text = "Albums of the Artist"
    }
    
    // MARK: - Selectors

    @objc private func didTapShare() {
        guard let url = URL(string: data?.external_urls["spotify"] ?? "") else { return }
        
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
    
    @objc private func clickRefresh() {
        self.errorLabel.isHidden = true
        self.errorButton.isHidden = true
        
        fetchArtistDetails()
    }
    
}


// MARK: - UITableViewDataSource

extension ArtistController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistAlbums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableCell.identifier,
            for: indexPath
        ) as? SearchResultSubtitleTableCell
        
        if let album = artistAlbums?[indexPath.row] {
            cell?.configure(
                with: SearchResultSubtitleTableCellViewModel(
                    title: album.name,
                    subtitle: "Released at: \(album.release_date)",
                    imageUrl: URL(string: album.images.first?.url ?? "")
                )
            )
        }
        
        return cell ?? UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate

extension ArtistController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let album = artistAlbums?[indexPath.row] {
            let vc = AlbumController(album: album)
            
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
