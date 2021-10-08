//
//  SearchResultsViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 08/10/21.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet public var tableView: UITableView!
    
    var items: [Searchable] = []
    var filteredItems: [Searchable] = []

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let constructor = ActivityConstructor.getInstance()
        constructor.getActivities { activities in
            self.items.append(contentsOf: activities)
            self.tableView.reloadData()
        }
    }
    
    /// Deselect row when returning to view.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /// Prepare activity screen for navigation.
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ActivitySegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let activityOverviewViewController = segue.destination as? ActivityOverviewViewController
        else {
            return
        }
        
        // Get activity in position and set for view
        if let activity = filteredItems[indexPath.row] as? Activity {
            activityOverviewViewController.activity = activity
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let item = filteredItems[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.getDescription()
        return cell
    }
}
