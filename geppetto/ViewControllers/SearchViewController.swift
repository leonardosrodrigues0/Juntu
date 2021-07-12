//
//  SearchViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

public class SearchViewController: UIViewController {
    @IBOutlet public var tableView: UITableView!
    
    var items: [Searchable] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredItems: [Searchable] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        ActivityConstructor.getAllActivitiesData { data in
            self.items.append(contentsOf: ActivityConstructor.buildStructs(data: data))
            self.tableView.reloadData()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter { (item: Searchable) -> Bool in
            return item.isResultWithSearchString(searchText) || isSearchBarEmpty
        }
      
        tableView.reloadData()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ActivitySegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let activityOverviewViewController = segue.destination as? ActivityOverviewViewController
        else {
            return
        }
        
        // Get activity in position and set for view
        // Force cast as there are only activities for 'Searchable' protocol for now
        let activity: Activity
        if isFiltering {
            activity = filteredItems[indexPath.row] as! Activity
        } else {
            activity = items[indexPath.row] as! Activity
        }
        
        activityOverviewViewController.activity = activity
    }

}

extension SearchViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredItems.count
        }
        
        return items.count
    }
  
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let item: Searchable
        if isFiltering {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.getDescription()
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
