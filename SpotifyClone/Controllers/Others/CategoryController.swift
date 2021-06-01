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
        
        configureColletionView()
        
        fetchPlaylists()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    private func configureColletionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
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
