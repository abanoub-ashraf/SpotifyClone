import UIKit

class PlaylistController: UIViewController {
    
    // MARK: - Variables -
    
    private let playlist: PlaylistModel
    
    private var tracks = [AudioTrackModel]()
    
    // this is the model.tracks.items that's coming from the api
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    // MARK: - UI -
    
    private let collectionView = UICollectionView(
        frame: .zero,
        // the compositional layout of one section that contains the playlist tracks
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                return PlaylistController.createSectionLayout()
            }
        )
    )
    
    // MARK: - Init -
    
    init(playlist: PlaylistModel) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        
        fetchPlaylistDetails()
        
        /// a button to share the playlist with other apps
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
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
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier
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
    
    private func fetchPlaylistDetails() {
        // pass the playlist that's passed to this controller to get its full details from the api
        NetworkManager.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    ///
                    /// the model we get from the api is the playlist details
                    /// we want to extract the tracks out of it
                    ///
                    case .success(let model):
                        ///
                        /// get the tracks so we can pass each one of them to the player
                        /// inside the didSelectRowAt() function
                        ///
                        self?.tracks = model.tracks.items.compactMap({ $0.track })
                        
                        /**
                         * we converts the response model we get from the api to a viewmodel
                           to fill the viewmodel property of this controller with it
                           so we can use it to fill the collection view with data
                         */
                        self?.viewModels = model.tracks.items.compactMap({
                            ///
                            /// get the items array from the api model response
                            /// then convert it into a view model one
                            ///
                            return RecommendedTracksCellViewModel(
                                name: $0.track.name,
                                artistName: $0.track.artists.first?.name ?? "-",
                                artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                            )
                        })
                        
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
        }
    }
    
    // MARK: - Selectors -
    
    /// share the playlist link with other apps
    @objc private func didTapShare() {
        // the playlist url we wanna share
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else { return }
        
        // the controller that will do the sharing
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        
        vc.view.backgroundColor = Constants.mainColor
        
        // so the app doesn't crash on the ipad
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // chagne the color inside of it after it's presented on the screen
        present(vc, animated: true) {
            UINavigationBar.appearance().tintColor = Constants.mainColor
        }
    }

}

// MARK: - UICollectionViewDataSource -

extension PlaylistController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
            for: indexPath
        ) as? RecommendedTracksCollectionViewCell else {
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
            name: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artworkURL: URL(string: playlist.images.first?.url ?? "")
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

extension PlaylistController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        ///
        /// pass the track to the player 
        ///
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlyback(from: self, track: track)
    }
    
}

// MARK: - PlaylistHeaderDelegate -

extension PlaylistController: PlaylistHeaderDelegate {
    
    ///
    /// implement the protocol delegate function that's gonna be called from the PlaylistHeader
    ///
    func playlistHeaderDidTapPlayAll(_ header: PlaylistHeader) {
        ///
        /// start playling the whole list of tracks
        ///
        PlaybackPresenter.shared.startPlyback(from: self, tracks: tracks)
    }
    
}
