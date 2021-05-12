import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables -
    
    // array of the Section Models for each section in the table view
    private var sections = [Section]()
    
    // MARK: - UI -
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()

    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the section models for each section in the table view
        configureModels()
        
        title = "Settings"
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    // array of the Section Models for each section in the table view
    private func configureModels() {
        sections.append(
            Section(
                title: "Profile",
                options: [
                    Option(title: "View Your Profile", handler: { [weak self] in
                        DispatchQueue.main.async {
                            self?.viewProfile()
                        }
                    })
                ]
            )
        )
        
        sections.append(
            Section(
                title: "Account",
                options: [
                    Option(title: "Sign Out", handler: { [weak self] in
                        DispatchQueue.main.async {
                            self?.signOutTapped()
                        }
                    })
                ]
            )
        )
    }
    
    // go tto the profile of the current user
    private func viewProfile() {
        let vc = ProfileController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // sign the current logged in user out
    private func signOutTapped() {
        
    }
    
    // MARK: - TableView Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // the number of the sections array elements
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of the options inside the sections array
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // the value of each option of the options of the sections array
        let model = sections[indexPath.section].options[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the model value of each row then call its handler
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // get each section then return its title value
        let model = sections[section]
        return model.title
    }
 
}
