import UIKit

@IBDesignable
class ActivityCardTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var card: ActivityCard!

    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
