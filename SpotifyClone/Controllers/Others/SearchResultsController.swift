import UIKit

/// a protocol that will make the search controller push a new controller
/// based on the result that gets tapped on in the search results controller
///
protocol SearchResultsControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

/// this controller will display the results of the search that happens inside the SearchController
///
class SearchResultsController: UIViewController {
    
    // MARK: - Variables -
    
    /// for the protocol we created above
    ///
    weak var delegate: SearchResultsControllerDelegate?
    
    /// the sections of the table view, each section will have its own array of items
    ///
    private var sections: [SearchSection] = []
    
    // MARK: - UI -
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(
            SearchResultDefaultTableCell.self,
            forCellReuseIdentifier: SearchResultDefaultTableCell.identifier
        )
        tableView.register(
            SearchResultSubtitleTableCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableCell.identifier
        )
        return tableView
    }()

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    /// this function will have the search results we get from the apin from the SearchController
    ///
    func update(with results: [SearchResult]) {
        /// grab each array element this results enum array (array of 4 elements, each element is ana rray)
        ///
        let artists = results.filter({
            switch $0 {
                case .artist:
                    // true means only grab this case from the results cause we want it
                    //
                    return true
                default:
                    return false
            }
        })
        
        let albums = results.filter({
            switch $0 {
                case .album:
                    return true
                default:
                    return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
                case .track:
                    return true
                default:
                    return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
                case .playlist:
                    return true
                default:
                    return false
            }
        })
        
        /// each element of this sections is a title and an array associatted with it
        /// make an array of 4 elements representing the 4 array we got above
        /// each array is gonna be an element in this SearchSection struct array
        ///
        self.sections = [
            /// first section of the sections array is gonna be the artists
            ///
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]
        
        tableView.reloadData()
        
        // hide the table view if there's no data in the array
        //
        tableView.isHidden = results.isEmpty
    }

}

// MARK: - UITableViewDataSource -

extension SearchResultsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// get the section we want then get its results array then get the result row from it
        ///
        let result = sections[indexPath.section].results[indexPath.row]
                
        /// we got in a section, then in its results array and grabed a result
        /// that result could be from any case array so we need to switch
        ///
        switch result {
            case .artist(model: let artist):
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: SearchResultDefaultTableCell.identifier,
                        for: indexPath
                ) as? SearchResultDefaultTableCell else {
                    return UITableViewCell()
                }
                
                let viewModel = SearchResultDefaultTableCellViewModel(
                    title: artist.name,
                    imageUrl: URL(string: artist.images?.first?.url ?? "")
                )
                
                cell.configure(with: viewModel)
                return cell
                
            case .album(model: let album):
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: SearchResultSubtitleTableCell.identifier,
                        for: indexPath
                ) as? SearchResultSubtitleTableCell else {
                    return UITableViewCell()
                }
                
                let viewModel = SearchResultSubtitleTableCellViewModel(
                    title: album.name,
                    subtitle: album.artists.first?.name ?? "",
                    imageUrl: URL(string: album.images.first?.url ?? "")
                )
                
                cell.configure(with: viewModel)
                return cell
                
            case .track(model: let track):
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: SearchResultSubtitleTableCell.identifier,
                        for: indexPath
                ) as? SearchResultSubtitleTableCell else {
                    return UITableViewCell()
                }
                
                let viewModel = SearchResultSubtitleTableCellViewModel(
                    title: track.name,
                    subtitle: track.artists.first?.name ?? "-",
                    imageUrl: URL(string: track.album?.images.first?.url ?? "")
                )
                
                cell.configure(with: viewModel)
                return cell
                
            case .playlist(model: let playlist):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchResultSubtitleTableCell.identifier,
                    for: indexPath
                ) as? SearchResultSubtitleTableCell else {
                    return UITableViewCell()
                }
            
                let viewModel = SearchResultSubtitleTableCellViewModel(
                    title: playlist.name,
                    subtitle: playlist.owner.display_name,
                    imageUrl: URL(string: playlist.images.first?.url ?? "")
                )
            
                cell.configure(with: viewModel)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
}

// MARK: - UITableViewDelegate -

extension SearchResultsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]

        /// send the result we clicked on to the delegate to push its controller from the SearchController
        /// cause this controller is not in a navigation stack
        ///
        delegate?.didTapResult(result)
    }
    
}
