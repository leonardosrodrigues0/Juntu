import UIKit

class MomentImageContentViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var imageView: UIImageView!
    private var imageData: Data?
    private var index: Int = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
    }

    func setup(imageData: Data, index: Int) {
        self.imageData = imageData
        self.index = index
    }
    
    /// Displays the image selected at Moments into UIImageView
    private func loadImage() {
        if let data = imageData {
            imageView.image = UIImage(data: data)
        }
    }
    
    func getIndex() -> Int {
        return index
    }
}
