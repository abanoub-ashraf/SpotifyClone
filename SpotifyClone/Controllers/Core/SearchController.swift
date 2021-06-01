import UIKit

class SearchController: UIViewController {
    
    // MARK: - Variables -
    
    private var categories = [CategoryModel]()
    
    // MARK: - UI -
    
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
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        )
    )

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        NetworkManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let categories):
                        ///
                        ///
                        self?.categories = categories
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        /// The object responsible for updating the contents of the search results controller
        ///
        searchController.searchResultsUpdater = self

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
    }

}

// MARK: - UICollectionViewDataSource -

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

// MARK: - UICollectionViewDelegate -

extension SearchController: UICollectionViewDelegate {
    
    
    
}

// MARK: - UISearchResultsUpdating -

/// to update the SearchResultsController with the results of the search we do in here
///
extension SearchController: UISearchResultsUpdating {
    
    /// Asks the object to update the search results for a specified controller
    ///
    func updateSearchResults(for searchController: UISearchController) {
        guard
            /**
             * get the searchResultsController of the searchController ui we created above
             * then cast it to the SearchResultsController we set inside the searchController ui anon block
             * so now we can access it's update() function that will take each result
               the search controller updates and display it inside that SearchResultsController
             */
            let resultsController = searchController.searchResultsController as? SearchResultsController,
            // make sure the query is not nil
            //
            let query = searchController.searchBar.text,
            // make sure it's not an empty white spaces either
            //
            !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        print(query)

//        resultsController.update(with: results)
//        perform search
//        NetworkManager.shared.search
    }
    
}
