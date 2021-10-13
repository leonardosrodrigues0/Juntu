//
//  SearchViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

public class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var resultsController: SearchResultsViewController
    var searchController: UISearchController
    
    // MARK: - Initializers
    public required init?(coder: NSCoder) {
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        guard let resultsViewController = storyboard.instantiateViewController(withIdentifier: "ResultsController") as? SearchResultsViewController else {
            return nil
        }
        
        resultsController = resultsViewController
        searchController = UISearchController(searchResultsController: resultsController)
        
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setSearchConfig()
    }
    
    private func setSearchConfig() {
        searchController.searchResultsUpdater = resultsController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
