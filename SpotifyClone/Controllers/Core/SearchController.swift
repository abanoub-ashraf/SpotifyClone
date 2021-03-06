import UIKit
import SafariServices
import MBProgressHUD

class SearchController: UIViewController {
    
    // MARK: - Variables
    
    private var categories = [CategoryModel]()
    
    // MARK: - UI
    
    let searchController: UISearchController = {
        /// vc is the search controller that will be the navigationItem's SearchController
        // SearchResultsController is the controller that will display the search results
        let vc = UISearchController(searchResultsController: SearchResultsController())
        // search bar is the area we use to type what we wanna search for
        vc.searchBar.placeholder = "Songs, Artists, Albums..."
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)
                    ),
                    subitem: item,
                    count: 2
                )
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 2, bottom: 7, trailing: 2)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        )
    )
    
    private let refreshControl = UIRefreshControl()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.isHidden = true
        label.text = "Failed to load! \nPlease check your \nInternet Connection \nand pull to Refresh"
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Constants.mainColor
        return label
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        label.center = view.center
        
        collectionView.frame = view.bounds
    }
        
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        /// The object responsible for updating the contents of the search results controller
        ///
        searchController.searchResultsUpdater = self
        
        /// to be able to perform search when the search bar's search button is clicked
        ///
        searchController.searchBar.delegate = self

        /// set the search controller of the navigation item to be the search controller we created
        ///
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    private func fetchCategories() {
        label.isHidden = true
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        categories.removeAll()
        collectionView.reloadData()

        NetworkManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                self?.label.isHidden = true
                
                switch result {
                    case .success(let categories):
                        ///
                        /// to fill the collection view with data using this categories array
                        ///
                        self?.categories = categories
                        
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)

                        self?.collectionView.reloadData()
                        
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        MBProgressHUD.hide(for: self?.view ?? UIView(), animated: true)
                        
                        self?.refreshControl.endRefreshing()
                        
                        self?.label.isHidden = false
                        
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    private func resetSearchResultsController() {
        guard let resultsController = searchController.searchResultsController as? SearchResultsController else {
            return
        }
        resultsController.reset()
    }
    
    // MARK: - Selectors

    @objc private func refresh(_ sender: Any) {
        categories = []
        
        fetchCategories()
    }

}

// MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        
        cell.configure(with: CategoryCollectionViewCellViewModel(
            title: category.name,
            artworkURL: URL(string: category.icons.first?.url ?? "")
        ))
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let category = categories[indexPath.row]
        
        let vc = CategoryController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchResultsController()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resetSearchResultsController()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard
            /**
             * get the searchResultsController of the searchController ui we created above
             * then cast it to the SearchResultsController we set inside the searchController ui element
             * so now we can access it's update() function that will take each result
               the search controller updates and display it inside that SearchResultsController
             */
            let resultsController = searchController.searchResultsController as? SearchResultsController,
            
            // make sure the query is not nil
            //
            let query = searchBar.text,
            
            // make sure it's not an empty white spaces either
            //
            !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        /// to use the SearchResultsControllerDelegate
        ///
        resultsController.delegate = self
        
        resultsController.startProgressHud(isLoading: true)
        
        resultsController.showLabel(isHidden: true)
        
        // perform the search api call
        //
        NetworkManager.shared.search(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let results):
                        /// update the searchBar's resultsController with the results we got from the api
                        ///
                        resultsController.update(with: results)
                        
                        resultsController.startProgressHud(isLoading: false)
                    case .failure(let error):
                        resultsController.startProgressHud(isLoading: false)
                        
                        resultsController.showLabel(isHidden: false)

                        print(error.localizedDescription)
                }
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating

/// to update the SearchResultsController with the results of the search we do in here
///
extension SearchController: UISearchResultsUpdating {
    
    /// Asks the object to update the search results for a specified controller
    ///
    func updateSearchResults(for searchController: UISearchController) {
    }
    
}

// MARK: - SearchResultsControllerDelegate

extension SearchController: SearchResultsControllerDelegate {
    
    /// switch on the result we got from the search results controller
    /// and display the controller that matches the result case we tapped on
    ///
    func didTapResult(_ result: SearchResult) {
        switch result {
            case .artist(model: let model):
                let vc = ArtistController(artist: model)
                
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
                
            case .album(model: let model):
                let vc = AlbumController(album: model)
                
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            
            case .track(model: let model):
                ///
                /// when a single track is tapped, present the player controller
                ///
                PlaybackPresenter.shared.startPlayback(from: self, track: model)
    
            case .playlist(model: let model):
                let vc = PlaylistController(playlist: model)
                
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
