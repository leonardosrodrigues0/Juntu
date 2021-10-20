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
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Register `TagCardCell` in collection view.
    private func initCollectionView() {
        let nib = UINib(nibName: tagCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.dataSource = self
        
        // Get tags from database and update collection view:
        let tagsDatabase = TagsDatabase.shared
        tagsDatabase.getTags { newTags in
            self.tags.append(contentsOf: newTags)
            self.collectionView.reloadData()
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
            cell?.setTag(tag)
        }
        
        return cell!
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    /// Return the item size for collection view.
    /// Use aspect ratio of 16:9 for two columns of items.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = CGFloat(10)
        let width: CGFloat = floor((collectionView.frame.size.width - horizontalSpacing) / 2)
        let height = width * (9 / 16)
        return CGSize(width: width, height: height)
    }
}
