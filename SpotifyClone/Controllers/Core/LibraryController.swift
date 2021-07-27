import UIKit

class LibraryController: UIViewController {

    // MARK: - Properties

    private let playlistsVC = LibraryPlaylistsController()
    private let albumsVC = LibraryAlbumsController()
    
    // MARK: - UI
    
    private let toggleView = LibraryToggleView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(toggleView)
        view.addSubview(scrollView)
        
        ///
        /// to implement the toggle delegte functions for scrolling between the child controllers
        /// whenever any of the buttons inside the toggle view is tapped
        ///
        toggleView.libraryToggleViewDelegate = self
        
        scrollView.delegate = self
        
        ///
        /// - this is the size of the scroll view
        ///
        /// - the width is twice so we can scroll horizontally between the scroll view's subviews
        ///
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        
        ///
        /// add children controllers to this controller
        ///
        addChildren()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        toggleView.frame = CGRect(
            x: (view.frame.size.width / 2) - 100,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 50
        )
    
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 55,
            width: view.width,
            height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55
        )
    }
    
    // MARK: - Helper Functions

    ///
    /// - add another controllers as children to this controller
    ///
    /// - add each child to the controller then to the scroll view, then set a frame to the child
    ///
    /// - call the didMove() for the child once it's added to a parent controller
    ///
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }

}

// MARK: - UIScrollViewDelegate

extension LibraryController: UIScrollViewDelegate {
    
    ///
    /// when we start scrolling change the layout of the indicator view in the toggle view to be under
    /// the other button in the toggle view
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100) {
            toggleView.update(for: .albums)
        } else {
            toggleView.update(for: .playlists)
        }
    }
    
}

// MARK: - LibraryToggleViewDelegate

extension LibraryController: LibraryToggleViewDelegate {
    
    ///
    /// scroll to 0 in the x axis to the playlists child controller when the playlists button inside
    /// the toggle view is tapped
    ///
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    ///
    /// - scroll to view.width in the x axis to the albums child controller when the albums button inside
    ///   the toggle view is tapped
    ///
    /// - view.width is the beginning of the albums child controller that we wanna scroll to
    ///
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(CGPoint(x: self.view.width, y: 0), animated: true)
        }
    }
    
}
