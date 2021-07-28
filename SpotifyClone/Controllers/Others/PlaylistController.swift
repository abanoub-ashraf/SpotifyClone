import UIKit

class PlaylistController: UIViewController {
    
    // MARK: - Variables
    
    private let playlist: PlaylistModel
    
    private var tracks = [AudioTrackModel]()
    
    // this is the model.tracks.items that's coming from the api
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    // MARK: - UI
    
    private let collectionView = UICollectionView(
        frame: .zero,
        // the compositional layout of one section that contains the playlist tracks
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                return PlaylistController.createSectionLayout()
            }
        )
    )
    
    private let refreshControl = UIRefreshControl()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Oops! There's nothing in here :("
        label.textColor = Constants.mainColor
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    // MARK: - Init
    
    init(playlist: PlaylistModel) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(noDataLabel)
        
        configureCollectionView()
        
        fetchPlaylistDetails()
        
        /// a button to share the playlist with other apps
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
        
        noDataLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        noDataLabel.center = view.center
    }
    
    // MARK: - Helper Functions
    
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
        
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
                        self?.collectionView.isHidden = false
                        self?.noDataLabel.isHidden = true
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.noDataLabel.isHidden = false
                        self?.collectionView.isHidden = true
                        self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    ///
    /// add a long tap gesture to the colletion view in the section that have the single tracks
    /// to add any one of them to a playlist after it gets long tapped
    ///
    private func addLongTapGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        
        collectionView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Selectors
    
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
    
    ///
    /// - long tap on any single track in the third section of the collection view to add that track
    ///   to any playlist we want
    ///
    /// - once the gesture began, get the row we long tap on in the collection view then create an index path
    ///   with it to get the track that we currenty long tap on, and make sure we're in the third section
    ///   that contain the single tracks as well
    ///
    /// - the action sheet will have the add button that will add the track to any playlist
    ///
    /// - once we choose the playlist we wanna add the track to, make the api call to add the track
    ///   to that playlist we selected from the child playlists controller
    ///
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to add this Song to a Playlist?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.view.tintColor = Constants.mainColor
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsController()
                
                vc.selectionHandler = { playlist in
                    NetworkManager.shared.addTrackToPlaylist(track: model, playlist: playlist) { [weak self] success in
                        self?.fetchPlaylistDetails()
                        createAlert(viewController: self ?? UIViewController())
                    }
                }
                
                vc.title = "Select Playlist"
                
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        })
                        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any) {
        fetchPlaylistDetails()
    }

}

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegate

extension PlaylistController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        ///
        /// pass the track to the player 
        ///
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
}

// MARK: - PlaylistHeaderDelegate

extension PlaylistController: PlaylistHeaderDelegate {
    
    ///
    /// implement the protocol delegate function that's gonna be called from the PlaylistHeader
    ///
    func playlistHeaderDidTapPlayAll(_ header: PlaylistHeader) {
        ///
        /// start playling the whole list of tracks
        ///
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
}
