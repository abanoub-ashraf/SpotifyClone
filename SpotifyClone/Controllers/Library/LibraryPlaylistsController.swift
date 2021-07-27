import UIKit

///
/// contains the playlists that the current user's created/saved
///
class LibraryPlaylistsController: UIViewController {
    
    // MARK: - Properties

    var playlists = [PlaylistModel]()
    
    // MARK: - UI

    ///
    /// this view will be shown only if there's no playlists to display inside this controller
    ///
    private let noPlaylistsView = ActionLabelView()
    
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
        
        view.addSubview(tableView)
        
        setupNoPlaylistsView()
        
        fetchCurrentUserPlaylistsFromAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noPlaylistsView.center = view.center
        
        tableView.frame = view.bounds
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
                text: "You don't have any Playlists yet",
                actionTitle: "Create a Playlist"
            )
        )
        
    }
    
    ///
    /// fetch the current user's playlists from the api
    ///
    private func fetchCurrentUserPlaylistsFromAPI() {
        NetworkManager.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let playlists):
                        self?.playlists = playlists
                        ///
                        /// to update the ui with the playists if we have or with an action label view
                        /// if we don't have playlists
                        ///
                        self?.updateUI()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    ///
    /// this will show an alert controller that will create a new playlist
    ///
    func showCreateNewPlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter the Playlist's Name",
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
            
            NetworkManager.shared.createNewPlaylist(with: text) { [weak self] success in
                if success {
                    self?.fetchCurrentUserPlaylistsFromAPI()
                } else {
                    print("Failed to create Playlist")
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
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
