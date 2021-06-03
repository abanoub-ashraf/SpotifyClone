import UIKit

class AlbumController: UIViewController {
    
    // MARK: - Variables -
    
    private let album: AlbumModel
    
    private var viewModels = [AlbumTracksCellViewModel]()
    
    // MARK: - UI -
    
    private let collectionView = UICollectionView(
        frame: .zero,
        // a collection view with one section
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                return AlbumController.createSectionLayout()
            }
        )
    )
    
    // MARK: - Init -
    
    init(album: AlbumModel) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        
        fetchAlbumDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        // use the same cell i used before for this collection view
        collectionView.register(
            AlbumTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTracksCollectionViewCell.identifier
        )
        
        // a header for the collection view to contain some info about the playlist
        collectionView.register(
            PlaylistHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeader.identifier
        )
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        /// add the  collection view header for this section
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    private func fetchAlbumDetails() {
        NetworkManager.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                /// same as what we did in the PlaylistController
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        return AlbumTracksCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                        )
                    })
                    
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource -

extension AlbumController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTracksCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumTracksCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    /// the header of the collection view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeader.identifier,
                for: indexPath
            ) as? PlaylistHeader,
            kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }

        /// create a view model out of the playlist that will be loaded by this controller
        /// then it will have the data that the header will have (data we extracted from the playlist model)
        let headerViewModel = PlaylistHeaderViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            /// from the date extension
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        
        /// then configure the header ui with the view model we made above
        header.configure(with: headerViewModel)
        
        /**
         * set the delegate property of the PlaylistHeader file that will call the protocol delegate function
           to start playling the list of tracks that are inside this controller
         */
        header.delegate = self
        
        return header
    }
    
}

// MARK: - UICollectionViewDelegate -

extension AlbumController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Play song
    }
    
}

// MARK: - PlaylistHeaderDelegate -

/**
 * palyist controller and this controller both comform to the PlaylistHeaderDelegate
 * the PlaylistHeaderDelegate is for the header of the both collection view in the two controller
 * the header has a play button that will play the tracks inside the 2 collection views in the two controllers
 */
extension AlbumController: PlaylistHeaderDelegate {
    
    /// implement the protocol delegate function that's gonna be called from the PlaylistHeader
    func playlistHeaderDidTapPlayAll(_ header: PlaylistHeader) {
        // start playling the tracks list in queue
        print("Playing All")
    }
    
}
