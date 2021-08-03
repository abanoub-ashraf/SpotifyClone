import UIKit
import MBProgressHUD

class PlaylistController: UIViewController {
    
    // MARK: - Variables
    
    private let playlist: PlaylistModel
    
    private var tracks = [AudioTrackModel]()
    
    // this is the model.tracks.items that's coming from the api
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    public var isOwner = false
    
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
        
        ///
        /// add a long gesture for the tracks rows in this controller to show an action sheet that asks to
        /// add the long tapped track to a playlist
        ///
        addLongPressGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchPlaylistDetails()
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
        MBProgressHUD.showAdded(to: view, animated: true)

        tracks.removeAll()
        
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
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        self?.collectionView.reloadData()
                        self?.collectionView.isHidden = false
                        self?.noDataLabel.isHidden = true
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        print(error.localizedDescription)
                        self?.noDataLabel.isHidden = false
                        self?.collectionView.isHidden = true
                }
            }
        }
    }
    
    ///
    /// add a long gesture for the tracks rows in this controller to show an action sheet that asks to
    /// add the long tapped track to a playlist
    ///
    private func addLongPressGesture() {
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
    /// long tap on any single track in the collection view to add it to a playlist
    ///
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
        let track = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: track.name,
            message: track.artists.first?.name,
            preferredStyle: .actionSheet
        )
        
        actionSheet.view.tintColor = Constants.mainColor
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsController()
                
                vc.selectionHandler = { playlist in
                    NetworkManager.shared.addTrackToPlaylist(track: track, playlist: playlist) { [weak self] success in                        
                        ///
                        /// post a notification that a track has been added to a playlist
                        ///
                        if success {
                            HapticsManager.shared.vibrate(for: .success)
                            
                            NotificationCenter.default.post(name: .trackAddedToOrDeletedFromPlaylistNotification, object: nil)
                            
                            DispatchQueue.main.async {
                                self?.fetchPlaylistDetails()
                            }
                            
                            createAlert(title: "Done!", message: "The song is added Successfully", viewController: self ?? UIViewController())
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        
                    }
                }
                
                vc.title = "Select Playlist"
                
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        })
        
        actionSheet.addAction(UIAlertAction(title: "Remove from the Playlist", style: .destructive) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            NetworkManager.shared.removeTrackFromPlaylist(track: track, playlist: strongSelf.playlist) { success in
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self?.view ?? UIView(), animated: true)

                    if success {
                        strongSelf.tracks.remove(at: indexPath.row)
                        strongSelf.viewModels.remove(at: indexPath.row)
                        strongSelf.collectionView.reloadData()
                        
                        ///
                        /// post a notification that a track has been deleted from a playlist
                        ///
                        if success {
                            HapticsManager.shared.vibrate(for: .success)
                            
                            NotificationCenter.default.post(name: .trackAddedToOrDeletedFromPlaylistNotification, object: nil)
                        }
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        createAlert(title: "Done!", message: "The song is deleted Successfully", viewController: strongSelf)
                    } else {
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        HapticsManager.shared.vibrate(for: .error)

                        createAlert(title: "Opps!", message: "Failed to delete the Song, Please try again", viewController: strongSelf)
                    }
                }
            }
        })
                        
        present(actionSheet, animated: true, completion: nil)
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
