import UIKit
import MBProgressHUD

///
/// contains the albums that the current user's created/saved
///
class LibraryAlbumsController: UIViewController {
    
    // MARK: - Properties

    var albums = [AlbumModel]()
    
    ///
    /// this observer is for the notification of the save an album and all it does is that it refetch
    /// the current user's saved albums from the server again
    ///
    private var observer: NSObjectProtocol?
    
    // MARK: - Init

    deinit {
        observer = nil
    }
    
    // MARK: - UI

    ///
    /// this view will be shown only if there's no albums to display inside this controller
    ///
    private let noAlbumsView = ActionLabelView()
    
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
    
        setupView()
                
        fetchCurrentUserSavedAlbumsFromAPI()
        
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        noAlbumsView.frame = CGRect(
            x: (view.width - 200) / 2,
            y: (view.height - 200) / 2,
            width: 200,
            height: 200
        )
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    // MARK: - Helper Functions
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        view.addSubview(tableView)
        
        setupNoAlbumsView()

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        
        tableView.addGestureRecognizer(gesture)
    }
    
    private func addObservers() {
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchCurrentUserSavedAlbumsFromAPI()
            }
        )
    }
    
    private func setupNoAlbumsView() {
        view.addSubview(noAlbumsView)
        
        noAlbumsView.actionLabelViewDelegate = self
        
        ///
        /// this will start off hidden and configured with a view model data
        ///
        noAlbumsView.configure(
            with: ActionLabelViewModel(
                text: "You have not saved any Albums yet. \nif you already did, then pull to refresh",
                actionTitle: "Browse"
            )
        )
        
    }
    
    ///
    /// fetch the current user's saved albums from the api
    ///
    private func fetchCurrentUserSavedAlbumsFromAPI() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        albums.removeAll()
        self.tableView.reloadData()
        
        NetworkManager.shared.getCurrentUserSavedAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let albums):
                        self?.albums = albums
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        ///
                        /// to update the ui with the albums if we have or with an action label view
                        /// if we don't have albums
                        ///
                        self?.updateUI()
                        
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        print(error.localizedDescription)
                        
                        self?.refreshControl.endRefreshing()
                        
                        self?.noAlbumsView.isHidden = false
                        
                        self?.tableView.isHidden = false
                }
            }
        }
    }

    ///
    /// to update the ui with the current user's saved albums in a table view if we have them
    /// or with an action label view if we don't
    ///
    private func updateUI() {
        if albums.isEmpty {
            tableView.reloadData()
            noAlbumsView.isHidden = false
            tableView.isHidden = false
        } else {
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    // MARK: - Selectors

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any) {
        fetchCurrentUserSavedAlbumsFromAPI()
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: tableView)
        
        guard
            let indexPath = tableView.indexPathForRow(at: touchPoint),
            indexPath.section == 0
        else {
            return
        }
        
        let model = albums[indexPath.row]
        
        let actionSheet = UIAlertController(
            title: model.name,
            message: "Would you like to remove this Album from Library?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.view.tintColor = Constants.mainColor
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                NetworkManager.shared.removeAlbumFromLibrary(album: model) { success in
                    if success {
                        DispatchQueue.main.async {
                            strongSelf.fetchCurrentUserSavedAlbumsFromAPI()
                            
                            HapticsManager.shared.vibrate(for: .success)
                        }
                        
                        createAlert(title: "Done!", message: "Album is removed Successfully", viewController: strongSelf)
                    } else {
                        createAlert(title: "Failed!", message: "", viewController: strongSelf)
                        
                        HapticsManager.shared.vibrate(for: .error)
                    }
                }
            }
        })
                        
        present(actionSheet, animated: true, completion: nil)
    }

    
}

// MARK: - ActionLabelViewDelegate

extension LibraryAlbumsController: ActionLabelViewDelegate {
    
    ///
    /// when there's no albums saved the button inside the action label view will trigger this delegate
    /// function to go to the first controller of the tab bar which is the browser screen
    ///
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        self.tabBarController?.selectedIndex = 0
    }
    
}

// MARK: - UITableViewDataSource

extension LibraryAlbumsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
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
        
        let album = albums[indexPath.row]
        
        cell.configure(
            with: SearchResultSubtitleTableCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "-",
                imageUrl: URL(string: album.images.first?.url ?? Constants.Images.albumsPlaceHolder)
            )
        )
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension LibraryAlbumsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        
        let vc = AlbumController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
