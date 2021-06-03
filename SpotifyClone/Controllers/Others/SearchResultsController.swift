import UIKit

/// this controller will display the results of the search that happens inside the SearchController
///
class SearchResultsController: UIViewController {
    
    // MARK: - Variables -
    
    /// the sections of the table view, each section will have its own array of items
    ///
    private var sections: [SearchSection] = []
    
    // MARK: - UI -
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        /// grab the array of each case of the results enum array
        /// grab the artists array, the first case of the results enum array param
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
        
        /// grab the albums array, the second case of the results enum array param
        ///
        let albums = results.filter({
            switch $0 {
                case .album:
                    return true
                default:
                    return false
            }
        })
        
        /// grab the tracks array, the third case of the results enum array param
        ///
        let tracks = results.filter({
            switch $0 {
                case .track:
                    return true
                default:
                    return false
            }
        })
        
        /// grab the playlists array, the fourth case of the results enum array param
        ///
        let playlists = results.filter({
            switch $0 {
                case .playlist:
                    return true
                default:
                    return false
            }
        })
        
        /// each element of this section is a title and an array associatted with it
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        /// we got in a section, then in its results array and grabed a result
        /// that result could be from any case array so we need to switch
        ///
        switch result {
            case .artist(model: let model):
                cell.textLabel?.text = model.name
            case .album(model: let model):
                cell.textLabel?.text = model.name
            case .track(model: let model):
                cell.textLabel?.text = model.name
            case .playlist(model: let model):
                cell.textLabel?.text = model.name
        }
        
        return cell
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

        switch result {
            case .artist(model: let model):
                break
                
            case .album(model: let model):
                let vc = AlbumController(album: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            
            case .track(model: let model):
                break
            
            case .playlist(model: let model):
                let vc = PlaylistController(playlist: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
