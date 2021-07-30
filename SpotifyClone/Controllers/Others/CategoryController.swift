import UIKit

class CategoryController: UIViewController {
    
    // MARK: - Variables -
    
    let category: CategoryModel
    
    private var playlists = [PlaylistModel]()
    
    // MARK: - UI -
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(250)
                    ),
                    subitem: item,
                    count: 2
                )
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        )
    )
    
    private let noPlaylistsView = ActionLabelView()
    
    private let refreshControl = UIRefreshControl()
        
    // MARK: - Init -
    
    init(category: CategoryModel) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.name
        
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        
        setupNoPlaylistsView()
        
        fetchPlaylists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
        
        ///
        /// to center a view we need to give it a frame first
        ///
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noPlaylistsView.center = view.center
    }
    
    // MARK: - Helper Functions -
    
    private func setupNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.actionLabelViewDelegate = self
        
        ///
        /// this will start off hidden and configured with a view model data
        ///
        noPlaylistsView.configure(
            with: ActionLabelViewModel(
                text: "There's Nothing in here, Pull to Refresh or go Back",
                actionTitle: "Go Back"
            )
        )
        
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        collectionView.register(
            FeaturedPlaylistsCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier
        )
        
    }
    
    private func fetchPlaylists() {
        NetworkManager.shared.getCategoryPlaylists(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let playlists):
                        self?.playlists = playlists
                        self?.updateUI()
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.refreshControl.endRefreshing()
                        self?.noPlaylistsView.isHidden = false
                }
            }
        }
    }
    
    ///
    /// to update the ui with the playists in a table view if we have or with an action label view
    /// if we don't have playlists
    ///
    private func updateUI() {
        if playlists.isEmpty {
            collectionView.reloadData()
            noPlaylistsView.isHidden = false
            collectionView.isHidden = false
        } else {
            collectionView.reloadData()
            noPlaylistsView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    // MARK: - Selectors
    
    @objc private func refresh(_ sender: Any) {
        playlists = []
        fetchPlaylists()
    }
    
}

// MARK: - UICollectionViewDataSource -

extension CategoryController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier,
            for: indexPath
        ) as? FeaturedPlaylistsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(with: FeaturedPlaylistsCellViewModel(
            name: playlist.name,
            artworkURL: URL(string: playlist.images.first?.url ?? ""),
            creatorName: playlist.owner.display_name
        ))
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate -

extension CategoryController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = PlaylistController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CategoryController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        navigationController?.popViewController(animated: true)
    }
    
}
