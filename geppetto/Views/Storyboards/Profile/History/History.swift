import UIKit

class History: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var historyView: UIView!
    @IBOutlet weak var tableViewHistory: UITableView!
    private let cellIdentifier = "ActivityCardTableViewCell"
    var activityList: [Activity] = []
    weak var activityNavigationDelegate: ActivityNavigationDelegate?
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Methods
        
    private func commonInit() {
        Bundle.main.loadNibNamed("History", owner: self, options: nil)
        addSubview(historyView)
        historyView.frame = self.bounds
        historyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initTableView()
    }
    
    func reloadCards(delegate: ActivityNavigationDelegate) {
        tableViewHistory.reloadData()
    }
    
    private func initTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableViewHistory.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
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

extension History: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ActivityCardTableViewCell
        let activity = activityList[indexPath.row]
        if let card = cell?.card {
            updateCardActivity(card: card, with: activity)
        }
        return cell!
    }
}

extension History: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let activity = activityList.get(at: indexPath.row) {
            self.activityNavigationDelegate?.navigate(to: activity)
        }
    }
}
