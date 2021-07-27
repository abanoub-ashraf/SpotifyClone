import UIKit

///
/// this's responsible for scrolling back and forth between the library playlists controller and
/// the library albums controller inside the library controller, whenever any of the buttons
/// inside the toggle view is tapped
///
protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    // MARK: - Properties

    weak var libraryToggleViewDelegate: LibraryToggleViewDelegate?
    
    ///
    /// use this variable to layout the indicator view under each button based on its value
    ///
    var state: State = .playlists
    
    // MARK: - UI

    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.mainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistsButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)

        albumsButton.frame = CGRect(x: playlistsButton.right, y: 0, width: 100, height: 40)
        
        ///
        /// start laying out the indicator view based on the default value of the state variable
        ///
        layoutIndicator()
    }
    
    // MARK: - Selectors

    @objc private func didTapPlaylists() {
        ///
        /// set the state to playlist so the indicator is layed out under the playlists button
        ///
        state = .playlists
        
        ///
        /// this will lay the indicator out based on the state variable
        ///
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        ///
        /// the playlists button inside this toggle view is tapped so, we will scroll to the library playlists
        /// controller inside the library controller
        ///
        libraryToggleViewDelegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums() {
        ///
        /// set the state to album so the indicator is layed out under the albums button
        ///
        state = .albums
        
        ///
        /// this will lay the indicator out based on the state variable
        ///
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        ///
        /// the albums button inside this toggle view is tapped so, we will scroll to the library albums
        /// controller inside the library controller
        ///
        libraryToggleViewDelegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    // MARK: - Helper Functions

    ///
    /// layout the indicator view under single button of the buttons based on
    /// the value of the state variable above
    ///
    func layoutIndicator() {
        switch state {
            case .playlists:
                indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom, width: 100, height: 3)
            case .albums:
                indicatorView.frame = CGRect(x: 100, y: playlistsButton.bottom, width: 100, height: 3)
        }
    }
    
    ///
    /// - this function is for laying the indicator view based on the scrolling
    ///   in the library controller
    ///
    /// - this function will get called from the library controller when the scrolling x offset
    ///   hits some value we will change the layout of the indicator to be under the other button
    ///
    func update(for state: State) {
        self.state = state
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
}
