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
    @IBOutlet weak var bannerViewContainer: UIView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutlets()
        let adManager = AdManager()
        let banner = adManager.addBannerViewToView(bannerViewContainer, with: self)
    }

    override func viewDidAppear(_ animated: Bool) {

    }
    
    private func updateOutlets() {
        guard let indexValue = index, let totalSteps = activity?.getSteps().count else {
            print("Error: failed to unwrap index optional at activity step.")
            return
        }
        
        guard let imageRef = step?.getImageDatabaseRef() else {
            return
        }

        image.sd_setImage(with: imageRef)
        indexLabel.text = "Passo \(indexValue + 1) de \(totalSteps)"
        instructions.text = step?.information
        if (step?.reference ?? "").isEmpty {
            juntuTip.removeFromSuperview()
        } else {
            juntuTipText.text = step?.reference
        }
    }
    
}
