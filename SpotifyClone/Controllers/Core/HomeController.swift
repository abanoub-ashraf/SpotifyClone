import UIKit

class HomeController: UIViewController {
    
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
        
        fetchData()
    }
    
    // MARK: - Helper Functions -
    
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
    
    // MARK: - Selectors -
    
    @objc func didTapSettings() {
        let vc = SettingsController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
