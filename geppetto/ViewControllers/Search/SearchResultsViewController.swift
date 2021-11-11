import UIKit

class SearchResultsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet public var tableView: UITableView!

    var items: [Searchable] = []
    var filteredItems: [Searchable] = []
    weak var activityNavigationDelegate: ActivityNavigationDelegate?
    
    private let cellIdentifier = "ActivityCardTableViewCell"

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            self.items.append(contentsOf: activities)
            self.tableView.reloadData()
        }
    }
    
    private func initTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
    }

    /// Deselect row when returning to view.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /// Instantiate the Card Views with data from activity
    private func updateCardActivity(card: ActivityCard, with activity: Activity) {
        card.activity = activity
        card.delegate = activityNavigationDelegate
        card.updateView()
        
        if let tagId = activity.tags?.first {
            TagsDatabase.shared.getTag(withId: tagId).then { tag in
                card.setTag(tag)
            }
        }
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {

    /// Called when search text is changed.
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    /// Update `filteredItems`.
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter { $0.isResultWithSearchString(searchText) }
        tableView.reloadData()
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActivityCardTableViewCell
        let item = filteredItems[indexPath.row]

        let card = cell?.card
        let activity = item as? Activity
        if card != nil && activity != nil {
            updateCardActivity(card: card!, with: activity!)
        }
        return cell!
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = filteredItems.get(at: indexPath.row) as? Activity {
            self.activityNavigationDelegate?.navigate(to: activity)
        }
    }
}
