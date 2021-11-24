import UIKit

class SavedActivities: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var savedView: UIView!
    @IBOutlet var savedTableView: UITableView!
    private let cellIdentifier = "ActivityCardTableViewCell"
    var items: [Activity] = []
    weak var activityNavigationDelegate: ActivityNavigationDelegate?
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Methods
        
    private func commonInit() {
        Bundle.main.loadNibNamed("SavedActivities", owner: self, options: nil)
        addSubview(savedView)
        savedView.frame = self.bounds
        savedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initTableView()
    }
    
    func reloadCards() {
        if items.isEmpty {
            EmptyViewHandler.setEmptyView(for: .saved, in: savedTableView)
        } else {
            savedTableView.backgroundView = nil
        }
        savedTableView.reloadData()
    }
    
    private func initTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        savedTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        savedTableView.delegate = self
        savedTableView.dataSource = self
    }
    
    private func updateCardActivity(card: ActivityCard, with activity: Activity) {
        card.activity = activity
        card.updateView()

        if let tagId = activity.tags?.first {
            TagsDatabase.shared.getTag(withId: tagId).then { tag in
                card.setTag(tag)
            }
        }
    }
}

extension SavedActivities: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActivityCardTableViewCell
        let activity = items[indexPath.row]
        if let card = cell?.card {
            updateCardActivity(card: card, with: activity)
        }
        return cell!
    }
}

extension SavedActivities: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = items.get(at: indexPath.row) {
            self.activityNavigationDelegate?.navigate(to: activity)
        }
    }
}
