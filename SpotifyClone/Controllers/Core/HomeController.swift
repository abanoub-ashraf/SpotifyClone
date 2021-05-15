import UIKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommendedTracks
}

class HomeController: UIViewController {
    
    // MARK: - UI -
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeController.createSectionsLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - LifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        configureCollectionView()
        
        view.addSubview(spinner)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    // fetch New Releases, Featured Playlists, Recommended Tracks
    func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
                case .success(let model):
                    let genres = model.genres
                    var seeds = Set<String>()

                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }

                    APICaller.shared.getRecommendations(genres: seeds) { _ in

                }
                case .failure(let error):
                    break
            }
        }
    }
    
    // create sections for the collection view
    private static func createSectionsLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
            case 0:
                /// the section that will display the fetch New Releases
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // the vertical group that goes inside the horizontal one
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        /**
                         * this must be equal to the height of its container
                         * each item inside this group will have height of
                           the container's height / number of the items which is 3
                         */
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    // number of the items in the group
                    count: 3
                )
                
                // the horizontal group is the main one that contains a vertical one
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.9),
                        // this is the height of what is inside this horzontal group
                        // what is inside should have the exact same height as well
                        heightDimension: .absolute(390)
                    ),
                    subitem: verticalGroup,
                    // number of the items in the group
                    count: 1
                )
                
                // the section is gonna be a horzintal group that contains a vertical one
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                // setting this and the group to be horizontal makes the collectionview a horizontal one
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            case 1:
                /// the section that will display the Featured Playlists
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(200)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: item,
                    count: 2
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            case 2:
                /// Recommended Tracks
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(80)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                return section
        }
    }
    
    // MARK: - Selectors -
    
    @objc func didTapSettings() {
        let vc = SettingsController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - CollectionView Functions -

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemGreen
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemPink
        } else if indexPath.section == 2 {
            cell.backgroundColor = .systemBlue
        }
        
        return cell
    }
    
}
