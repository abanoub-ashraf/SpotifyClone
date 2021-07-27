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
    
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
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
                text: "You don't have Any Playlists yet.",
                actionTitle: "Create"
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
/// <# Comment #>
///
extension LibraryPlaylistsController: ActionLabelViewDelegate {
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        
    }
    
}
