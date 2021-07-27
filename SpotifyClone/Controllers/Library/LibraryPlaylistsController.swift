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
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
        setupNoPlaylistsView()
        
        fetchCurrentUserPlaylistsFromAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noPlaylistsView.center = view.center
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
    /// to update the ui with the playists if we have or with an action label view
    /// if we don't have playlists
    ///
    private func updateUI() {
        if playlists.isEmpty {
            noPlaylistsView.isHidden = false
        } else {
            // show table
        }
    }
    
}

// MARK: - ActionLabelViewDelegate

///
/// implement create new playlist inside this controller whenever the create playlist button inside
/// the action label view is clicked
///
extension LibraryPlaylistsController: ActionLabelViewDelegate {
    
    ///
    /// this is the delegate function that will create a new playlist and add it to the playlists
    /// table view inside this controller
    ///
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
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
            
            NetworkManager.shared.createNewPlaylist(with: text) { success in
                if success {
                    // refresh list of playlists
                } else {
                    print("Failed to create Playlist")
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
