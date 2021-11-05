//
//  SearchViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

public class SearchViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var resultsController: SearchResultsViewController
    var searchController: UISearchController
    private var tags = [Tag]()
    private var selectedTagCell: Tag?
    private var selectedActivity: Activity?
    
    private let tagCellIdentifier = "TagCardCell"
    
    // MARK: - Initializers
    public required init?(coder: NSCoder) {
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        guard let resultsViewController = storyboard.instantiateViewController(withIdentifier: "ResultsController") as? SearchResultsViewController else {
            return nil
        }
        
        resultsController = resultsViewController
        searchController = UISearchController(searchResultsController: resultsController)
        
        super.init(coder: coder)
        
        resultsController.activityNavigationDelegate = self
    }
    
    // MARK: - Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setSearchConfig()
        initCollectionView()
    }
    
    /// Configure search controller and search bar.
    private func setSearchConfig() {
        searchController.searchResultsUpdater = resultsController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar brincadeiras"
        searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    /// Register `TagCardCell` in collection view.
    /// Get tags from database and reload collection view data.
    private func initCollectionView() {
        let nib = UINib(nibName: tagCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.dataSource = self
        
        // Get tags that have at least one activity.
        let loadingHandler = LoadingHandler(parentView: view)
        TagsDatabase.shared.getNonEmptyTags().then { tags in
            loadingHandler.stop()
            self.tags = tags
            self.collectionView.reloadData()
        }
    }
    
    /// Prepare for navigate to Tag
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTag" {
            // Get the first child of navigation controller,
            // which is supposed to be TagViewController.
            guard let tagViewController = segue.destination as? TagViewController else { return }
            tagViewController.viewTag = selectedTagCell
        }
        if segue.identifier == "goToActivityOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Return total number of items.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    /// Return the cell for a given index.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as? TagCardCell
        
        // Set cell tag element:
        if let tag = tags.get(at: indexPath.row) {
            cell?.cellTag = tag
        }
        
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tag = tags.get(at: indexPath.row) {
            selectedTagCell = tag
        }
        
        performSegue(withIdentifier: "goToTag", sender: self)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    /// Return the item size for collection view.
    /// Use aspect ratio of 16:9 for two columns of items.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Space between cells: (defined only here)
        let horizontalSpacing = CGFloat(10)
        // Space between cells and safe area (horizontally): (defined in the storyboard)
        let contentInsets = CGFloat(16) // defined in the storyboard
        // Width must be (totalWidth - 2 * contentInsets - horizontalSpacing) / 2
        let width: CGFloat = floor((collectionView.frame.size.width - 2 * contentInsets - horizontalSpacing) / 2)
        let height = width * (9 / 16)
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: ActivityNavigationDelegate {
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToActivityOverview", sender: self)
    }
}
