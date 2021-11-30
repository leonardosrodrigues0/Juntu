import UIKit
import FirebaseStorage

/// Individual activity step screen
class ActivityStepViewController: UIViewController {

    // MARK: - Properties
    
    var activity: Activity?
    var index: Int? // PageController index.
    var step: ActivityStep?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var juntuTip: UIStackView!
    @IBOutlet weak var juntuTipText: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    // MARK: - Methods
    
    override func viewDidLoad() {
        setBackgroundColor()
        super.viewDidLoad()
        updateOutlets()
        setupBottomConstraint()
    }
    
    private func setupBottomConstraint() {
        if let shouldDisplayAds = Bundle.main.infoDictionary?["shouldDisplayAds"] as? Bool, shouldDisplayAds {
            insertAdSpace()
        } else {
            removeAdSpace()
        }
    }
    private func insertAdSpace() {
        /// This 20 comes from pageControl height
        scrollViewBottomConstraint.constant = AdManager.height + 20
    }
    private func removeAdSpace() {
        /// This 20 comes from pageControl height
        scrollViewBottomConstraint.constant = 20
    }
    
    private func setBackgroundColor() {
        image.backgroundColor = .systemGray4
    }
    
    private func updateOutlets() {
        
        guard let indexValue = index, let totalSteps = activity?.getSteps().count else {
            print("Error: failed to unwrap index optional at activity step.")
            return
        }

        image.image = ActivityOverviewViewController.stepsImages[indexValue + 1]
        indexLabel.text = "Passo \(indexValue + 1) de \(totalSteps)"
        instructions.text = step?.information
        if (step?.reference ?? "").isEmpty {
            juntuTip.removeFromSuperview()
        } else {
            juntuTipText.text = step?.reference
        }
    }
    
}
