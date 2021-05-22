import UIKit

class PlaylistController: UIViewController {
    
    // MARK: - Variables -
    
    private let playlist: PlaylistModel
    
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
        
        NetworkManager.shared.getPlaylistDetails(for: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }

}

