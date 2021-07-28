import UIKit

class AlbumController: UIViewController {
    
    // MARK: - Variables
    
    private let album: AlbumModel
    
    private var tracks = [AudioTrackModel]()
    
    private var viewModels = [AlbumTracksCellViewModel]()
    
    // MARK: - UI
    
    private let collectionView = UICollectionView(
        frame: .zero,
        // a collection view with one section
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                return AlbumController.createSectionLayout()
            }
        )
    )
    
    // MARK: - Init
    
    init(album: AlbumModel) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        
        fetchAlbumDetails()
        
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper Functions
    
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
                    ///
                    /// same as what we did in the PlaylistController
                    ///
                    case .success(let model):
                        self?.tracks = model.tracks.items
                        
                        self?.viewModels = model.tracks.items.compactMap({
                            return AlbumTracksCellViewModel(
                                name: $0.name,
                                artistName: $0.artists.first?.name ?? "-"
                            )
                        })
                        
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
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
                        createAlert(viewController: self ?? UIViewController())
                    }
                }
                
                vc.title = "Select Playlist"
                
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        })
                        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegate

extension AlbumController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        ///
        /// same as in the playlist controller file
        ///
        var track = tracks[indexPath.row]
        ///
        /// give the current alum to each track the user tap on so we can display the image of the album
        /// when any track is played
        ///
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
}

// MARK: - PlaylistHeaderDelegate

/**
 * palyist controller and this controller both comform to the PlaylistHeaderDelegate
 * the PlaylistHeaderDelegate is for the header of the both collection view in the two controller
 * the header has a play button that will play the tracks inside the 2 collection views in the two controllers
 */
extension AlbumController: PlaylistHeaderDelegate {
    
    /// implement the protocol delegate function that's gonna be called from the PlaylistHeader
    func playlistHeaderDidTapPlayAll(_ header: PlaylistHeader) {
        ///
        /// - create a copy of the tracks to give the current album to each one of those tracks
        ///   cause the single track model doesn't have its album property in the api response
        ///   so we give it here manually so we can get the images of that album when we play a single track in the
        ///   player controller
        ///
        /// - then pass the new copy of tracks to the presenter so we can display the image of each track inside
        ///   the player, the images that comes from that album property that we gave manually
        ///
        let tracksWithAlbum: [AudioTrackModel] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        ///
        /// same as in the playlist controller file
        ///
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
    
}
