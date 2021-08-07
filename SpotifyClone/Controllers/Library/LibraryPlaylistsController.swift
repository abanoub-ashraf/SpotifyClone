import UIKit
import MBProgressHUD

///
/// contains the playlists that the current user's created/saved
///
class LibraryPlaylistsController: UIViewController {
    
    // MARK: - Properties

    var playlists = [PlaylistModel]()
    
    ///
    /// - this closure is for selecting the playlist we wanna add a specific track to it
    ///
    /// - this whole controller will be used inside from inside the home controller when we long press
    ///   on any single track and an action sheet shows up with an add button to add that track to
    ///   one of the playlists in this controller
    ///
    var selectionHandler: ((PlaylistModel) -> Void)?
    
    ///
    /// this observer is for the notification of the add or remove from a playlist and all it does is that
    /// it refetch the current user's playlists from the server again
    ///
    private var observer: NSObjectProtocol?
    
    // MARK: - Init

    deinit {
        observer = nil
    }
    
    // MARK: - UI

    ///
    /// this view will be shown only if there's no playlists to display inside this controller
    ///
    private let noPlaylistsView = ActionLabelView()
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableCell.identifier
        )
        tableView.isHidden = true
        return tableView
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        view.addSubview(tableView)
        
        setupNoPlaylistsView()
        
        fetchCurrentUserPlaylistsFromAPI()
        
        ///
        /// if there's a playlist that's selected after a long press on a single track to add that track to it
        /// then show a close left bar button item
        ///
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose)
            )
        }
        
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noPlaylistsView.center = view.center
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Helper Functions
    
    private func addObservers() {
        observer = NotificationCenter.default.addObserver(
            forName: .trackAddedToOrDeletedFromPlaylistNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchCurrentUserPlaylistsFromAPI()
            }
        )
    }
    
    private func setupNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.actionLabelViewDelegate = self
        
        ///
        /// this will start off hidden and configured with a view model data
        ///
        noPlaylistsView.configure(
            with: ActionLabelViewModel(
                text: "You don't have any Playlists yet, pull to Refresh or create a New One",
                actionTitle: "Create a Playlist"
            )
        )
        
    }
    
    ///
    /// fetch the current user's playlists from the api
    ///
    private func fetchCurrentUserPlaylistsFromAPI() {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        playlists.removeAll()
        tableView.reloadData()
        
        NetworkManager.shared.getCurrentUserPlaylists { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    case .success(let playlists):
                        strongSelf.playlists = playlists
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        ///
                        /// to update the ui with the playists if we have or with an action label view
                        /// if we don't have playlists
                        ///
                        strongSelf.updateUI()
                        
                        strongSelf.refreshControl.endRefreshing()
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        print(error.localizedDescription)
                        
                        strongSelf.refreshControl.endRefreshing()
                        
                        self?.noPlaylistsView.isHidden = false
                        
                        self?.tableView.isHidden = false
                }
            }
        }
    }
    
    ///
    /// this will show an alert controller that will create a new playlist
    ///
    func showCreateNewPlaylistAlert() {
        let alert = UIAlertController(
            title: "Create New Playlist",
            message: "",
            preferredStyle: .alert
        )
        
        alert.view.tintColor = Constants.mainColor
        
        alert.addTextField { textField in
            textField.placeholder = "Playlist Name..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard
                let field = alert.textFields?.first,
                let text = field.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }
            
            guard !text.isEmpty else { return }
            
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view ?? UIView(), animated: true)
            }
            
            NetworkManager.shared.createNewPlaylist(with: text) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                    }
                    
                    HapticsManager.shared.vibrate(for: .success)
                    
                    self?.fetchCurrentUserPlaylistsFromAPI()
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                    }
                    
                    HapticsManager.shared.vibrate(for: .error)
                    
                    print("Failed to create Playlist")
                
                    guard let unwrappedSelf = self else { return }
                    
                    createAlert(title: "Oops!", message: "Failed to create Playlist", viewController: unwrappedSelf)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    ///
    /// to update the ui with the playists in a table view if we have or with an action label view
    /// if we don't have playlists
    ///
    private func updateUI() {
        if playlists.isEmpty {
            tableView.reloadData()
            noPlaylistsView.isHidden = false
            tableView.isHidden = false
        } else {
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // MARK: - Selectors

    @objc func didTapClose() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any) {
        playlists = []
        fetchCurrentUserPlaylistsFromAPI()
    }
    
}

// MARK: - ActionLabelViewDelegate

///
/// - implement create new playlist inside this controller whenever the create playlist button inside
///   the action label view is clicked
///
/// - that create button will be visible only if there's no playlists in the playlists array
///
extension LibraryPlaylistsController: ActionLabelViewDelegate {
    
    ///
    /// - this is the delegate function that will create a new playlist and add it to the playlists
    ///   table view inside this controller
    ///
    /// - the new playlist createion will happen inside the showCreateNewPlaylist() functions
    ///
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreateNewPlaylistAlert()
    }
    
}

// MARK: - UITableViewDataSource

extension LibraryPlaylistsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableCell
        else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(
            with: SearchResultSubtitleTableCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageUrl: URL(string: playlist.images.first?.url ?? Constants.Images.playlistPlaceHolder)
            )
        )
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension LibraryPlaylistsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let playlist = playlists[indexPath.row]
        
        ///
        /// - if the selection handler is nil then we wanna open the selected playlist in its controller
        ///   to view its songs and play them all or single ones of them
        ///
        /// - if not nill then we long pressed on a single track and the selected playlist is gonna have
        ///   this single track we wanna add to it
        ///
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            
            dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            
            return
        }
        
        let vc = PlaylistController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        
        vc.isOwner = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
