import UIKit
import MBProgressHUD

class HomeController: UIViewController {
    
    // MARK: - Variables
    
    // array of sections for the collection view sections
    private var sections = [BrowseSectionType]()
    
    /// to use the models we get from the api calls
    private var newAlbums: [AlbumModel]    = []
    private var playlists: [PlaylistModel] = []
    private var tracks: [AudioTrackModel]  = []
    
    // MARK: - UI
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        // setup the collection view compositional layout
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeController.createSectionsLayout(section: sectionIndex)
    })
    
    private let noPlaylistsView = ActionLabelView()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        configureCollectionView()
        
        fetchData()
        
        addLongTapGesture()
        
        setupNoPlaylistsView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noPlaylistsView.center = view.center
        
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Helper Functions
    
    private func setupNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.actionLabelViewDelegate = self
        
        ///
        /// this will start off hidden and configured with a view model data
        ///
        noPlaylistsView.configure(
            with: ActionLabelViewModel(
                text: "Failed to load! \nPlease check your Intertnet Connection \nand try again",
                actionTitle: ""
            )
        )
        
        noPlaylistsView.button.isHidden = true
        noPlaylistsView.label.textColor = Constants.mainColor
        
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
                
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        /// each section in the collection view is gonna use its own different cell
        collectionView.register(
            NewReleasesCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier
        )
        
        collectionView.register(
            FeaturedPlaylistsCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier
        )
        
        collectionView.register(
            RecommendedTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier
        )
        
        /// register the header of each section of the collection view
        collectionView.register(
            TitleHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeader.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        
    }
    
    // fetch the New Releases, Featured Playlists, Recommended Tracks data from their 3 api calls
    func fetchData() {
        self.noPlaylistsView.isHidden = true
        
        newAlbums.removeAll()
        tracks.removeAll()
        playlists.removeAll()
        sections.removeAll()
        
        collectionView.reloadData()
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        // enter the execution of the nubmer of the api calls we wanna execute
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
                
        // 3 models to get the response from each api call
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // get the New Releases from the api
        NetworkManager.shared.getNewAlbumsReleases { result in
            /// defer let us set up some work to be performed when the current scope exits
            defer {
                // this is gonna get executed once getting the result is done
                group.leave()
            }
            
            switch result {
                case .success(let model):
                    newReleases = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
        
        // get the Featured Playlists from the api
        NetworkManager.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            
            switch result {
                case .success(let model):
                    featuredPlaylists = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
        
        // get the Recommended genres from the api so we can get the recommended tracks
        NetworkManager.shared.getRecommendedGenres { result in
            switch result {
                case .success(let model):
                    let genres = model.genres
                    var seeds = Set<String>()

                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }

                    // get the Recommended Tracks from the api
                    // this needs 5 random genres from the api call above
                    NetworkManager.shared.getRecommendations(genres: seeds) { recommendedResult in
                        defer {
                            group.leave()
                        }
                        
                        switch recommendedResult {
                            case .success(let model):
                                recommendations = model
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                                break
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    break
            }
        }
        
        ///
        /// once the 3 api calls are dont getting the data notify the main thread with that
        ///
        group.notify(queue: .main) {
            if (newReleases == nil) || (featuredPlaylists == nil) || (recommendations == nil) {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.noPlaylistsView.isHidden = false
                    self.refreshControl.endRefreshing()
                    self.sections = []
                    self.collectionView.reloadData()
                }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.noPlaylistsView.isHidden = true
            
            self.refreshControl.endRefreshing()
            
            guard
                // extract the data we wanna use from the responses models we got from the api
                let newAlbums = newReleases?.albums.items,
                let playlists = featuredPlaylists?.playlists.items,
                let tracks = recommendations?.tracks
            else {
                return
            }
            
            ///
            /// pass the data we extracted to this function to convert them into 3 viewmodels
            ///
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
    }
    
    // convert the models params into viewmodels so we can append those viewmodels to the sections enums array
    private func configureModels(newAlbums: [AlbumModel], playlists: [PlaylistModel], tracks: [AudioTrackModel]) {
        /// save the models we get from the api to use them to access their individual items
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        // convert the newAlbums array into a viewmodel array then append it to the sections array
        /// news releases are the new albums that are released
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artWorkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        })))
        
        // convert the playlists array into a viewmodel array then append it to the sections array
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturedPlaylistsCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name
            )
        })))
        
        // convert the tracks array into a viewmodel array then append it to the sections array
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTracksCellViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "-",
                artworkURL: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        
        self.noPlaylistsView.isHidden = true
        
        self.collectionView.reloadData()
    }
    
    // create the layouts for the collection view sections
    private static func createSectionsLayout(section: Int) -> NSCollectionLayoutSection {
        /// the layout of the header of each section in the collection view
        let supplementaryHeaderView = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
            case 0:
                /// the section that will display the fetch New Releases
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // the vertical group that goes inside the horizontal one
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        /**
                         * this must be equal to the height of its container
                         * each item inside this group will have height of
                           the container's height / number of the items which is 3
                         */
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    // number of the items in the group
                    count: 3
                )
                
                // the horizontal group is the main one that contains a vertical one
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.9),
                        // this is the height of what is inside this horzontal group
                        // what is inside should have the exact same height as well
                        heightDimension: .absolute(390)
                    ),
                    subitem: verticalGroup,
                    // number of the items in the group
                    count: 1
                )
                
                // the section is gonna be a horzintal group that contains a vertical one
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                // setting this and the group to be horizontal makes the collectionview a horizontal one
                section.orthogonalScrollingBehavior = .groupPaging
                
                /// assign the header layout we created to each section
                section.boundarySupplementaryItems = supplementaryHeaderView
                
                return section
            case 1:
                /// the section that will display the Featured Playlists
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(200)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: item,
                    count: 2
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                
                /// assign the header layout we created to each section
                section.boundarySupplementaryItems = supplementaryHeaderView
                
                return section
            case 2:
                /// Recommended Tracks
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
                        heightDimension: .absolute(70)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                /// assign the header layout we created to each section
                section.boundarySupplementaryItems = supplementaryHeaderView
                
                return section
            default:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                /// assign the header layout we created to each section
                section.boundarySupplementaryItems = supplementaryHeaderView
                
                return section
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
    
    @objc func didTapSettings() {
        let vc = SettingsController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
        
        guard
            let indexPath = collectionView.indexPathForItem(at: touchPoint),
            indexPath.section == 2
        else {
            return
        }
        
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
                        
                        ///
                        /// post a notification that a track has been added to a playlist
                        ///
                        if success {
                            HapticsManager.shared.vibrate(for: .success)
                            
                            NotificationCenter.default.post(name: .trackAddedToOrDeletedFromPlaylistNotification, object: nil)
                            
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
                        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any) {
        sections = []
        
        fetchData()
    }

}

extension HomeController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // each section in this array is a viewmodel array
        let type = sections[section]
        
        switch type {
            // return the count of each array inside each section cause each section has different amount of data
            case .newReleases(let viewModels):
                return viewModels.count
            case .featuredPlaylists(let viewModels):
                return viewModels.count
            case .recommendedTracks(let viewModels):
                return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // each type is an enum element that contains array of viewmodels
        let type = sections[indexPath.section]
        
        switch type {
            // each case element has viewmodels array
            case .newReleases(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                    for: indexPath
                ) as? NewReleasesCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                // get every single viewmodel and configure the cell with it
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                
                return cell
            case .featuredPlaylists(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier,
                    for: indexPath
                ) as? FeaturedPlaylistsCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                
                return cell
            case .recommendedTracks(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                    for: indexPath
                ) as? RecommendedTracksCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeader.identifier,
                for: indexPath
            ) as? TitleHeader,
            kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        /// grab the title of ecah case inside the enum array
        header.configure(with: sections[indexPath.section].title)
        
        return header
    }
    
}

// MARK: - UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let section = sections[indexPath.section]
        
        switch section {
            case .featuredPlaylists:
                ///
                /// this home controller display all the playlists
                /// we need to get each playlist the user select to display its full details in a new controller
                ///
                let playlist = playlists[indexPath.row]
                
                /**
                 * i can pass the selected album to the album controller as computed property
                   or use this current way of passing it to the initializer of the album controller
                 */
                let vc = PlaylistController(playlist: playlist)
                vc.title = playlist.name
                vc.navigationItem.largeTitleDisplayMode = .never
                
                navigationController?.pushViewController(vc, animated: true)
                
            case .newReleases:
                let album = newAlbums[indexPath.row]
                
                /**
                 * i can pass the selected album to the album controller as computed property
                   or use this current way of passing it to the initializer of the album controller
                 */
                let vc = AlbumController(album: album)
                vc.title = album.name
                vc.navigationItem.largeTitleDisplayMode = .never
                
                navigationController?.pushViewController(vc, animated: true)
                
            case .recommendedTracks:
                ///
                /// present the player controller when a track is tapped
                ///
                let track = tracks[indexPath.row]
                PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
}
