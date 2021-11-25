import UIKit

/// Control of the PageViewController for a given activity
class ActivityPageControlViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var contentView: UIView!
    var activity: Activity?
    var helper = AnalyticsHelper()
    
    var pageViewController: ActivityPageViewController?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper = AnalyticsHelper()
        configurePageViewController()
    }
    
    /// Set options for pages
    func configurePageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(
            withIdentifier: String(describing: ActivityPageViewController.self)
        ) as? ActivityPageViewController else {
            return
        }
        
        self.pageViewController = pageViewController
        
        if activity != nil {
            pageViewController.setActivity(activity!)
        }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[pageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[pageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
    }
}

extension ActivityPageControlViewController: CameraManager {
    
    @IBAction private func cameraButtonTapped() {
        tryTakePicture()
    }
    
    /// Called when image picker finished getting an image. Dismiss picker and prompt for confirmation.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        promptImageConfirmation(with: info, to: picker)
    }
    
    /// Dismiss picker, add watermark to image and handle conformation flow for saving and sharing.
    private func promptImageConfirmation(with info: [UIImagePickerController.InfoKey: Any], to picker: UIImagePickerController) {
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found while unwrapping ImagePicker info")
            return
        }
        
        let editor = ImageEditor(image)
        let watermarkedImage = editor.withWatermark
        
        let helper = SaveShareHelper(owner: self)
        helper.saveImageToMomentsAndPromptForMore(for: watermarkedImage, activity: activity)
    }
    
}
