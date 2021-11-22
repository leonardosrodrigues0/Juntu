import UIKit

class FullscreenImageViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!

    var images: [Data] = [Data]()
    var currentImageIndex: Int = 0
    
    // used in `swipeToDismiss` to keep track of user interaction
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBar()
        configViewControllerStyle()
        
        // add pull-down gesture to dismiss modal
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeToDismiss(sender:))))
    }
    
    // MARK: - Private Methods

    private func configViewControllerStyle() {
        // force dark mode
        overrideUserInterfaceStyle = .dark
        // remove awkward bottom border from navbar
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func configNavigationBar() {
        // define close button in navbar
        navItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton(sender:))
        )
        
        // define more button in navbar
        //        navItem.rightBarButtonItem = UIBarButtonItem(
        //            image: UIImage(systemName: "ellipsis"),
        //            style: .plain,
        //            target: self,
        //            action: #selector(didTapMoreButton(sender:))
        //        )
        
        updateNavBarTitle()
    }
    
    //    private func createActionSheet() -> UIAlertController {
    //        // create alert
    //        let alert = UIAlertController(
    //            title: nil,
    //            message: nil,
    //            preferredStyle: .actionSheet
    //        )
    //
    //        // create actions
    //        let shareAction = UIAlertAction(title: "Compartilhar", style: .default) {_ in
    //            print("Compartilhar")
    //        }
    //
    //        let useAsProfileImageAction = UIAlertAction(title: "Usar como foto do perfil", style: .default) {_ in
    //            print("Usar como foto do perfil")
    //        }
    //
    //        let goToActivityAction = UIAlertAction(title: "Ir para atividade", style: .default) {_ in
    //            print("Ir para atividade")
    //        }
    //
    //        let deletePhotoAction = UIAlertAction(title: "Apagar foto", style: .destructive) {_ in
    //            print("Apagar foto")
    //        }
    //
    //        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    //
    //        // add actions to alert
    //        alert.addAction(shareAction)
    //        alert.addAction(useAsProfileImageAction)
    //        alert.addAction(goToActivityAction)
    //        alert.addAction(deletePhotoAction)
    //        alert.addAction(cancelAction)
    //
    //        return alert
    //    }
    
    /// Set title of View according to current image index
    private func updateNavBarTitle() {
        navItem.title = "\(currentImageIndex + 1) de \(images.count)"
    }
    
    // MARK: - Actions
    
    /// Dismiss this View Controller when user swipe down
    @objc private func swipeToDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    /// Dismiss this ViewController. Triggered when close button is tapped
    @objc private func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Show action sheet when more button is tapped
    //    @objc private func didTapMoreButton(sender: UIBarButtonItem) {
    //        let actionSheet = createActionSheet()
    //        present(actionSheet, animated: true)
    //    }

    // MARK: - Child View Controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "childView" {
            guard let pageMomentsViewController = segue.destination as? PageMomentsViewController else { return }
            
            pageMomentsViewController.delegate = self
            pageMomentsViewController.dataSource = self
            
            // instantiate moment image content view controller
            if let initialMomentImageContentVC = storyboard?.instantiateViewController(
                withIdentifier: "momentImageContent"
            ) as? MomentImageContentViewController {
                // define selected image to be presented
                initialMomentImageContentVC.setup(imageData: images[currentImageIndex], index: currentImageIndex)
                // put created VC in pageVC
                pageMomentsViewController.setViewControllers([initialMomentImageContentVC], direction: .forward, animated: true, completion: nil)
                
            }
        }
    }
}

// MARK: - Page Controller Delegate Methods

extension FullscreenImageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    /// Pre-load previous page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard
            let currentVC = viewController as? MomentImageContentViewController,
            let momentImageContentVC = storyboard?.instantiateViewController(
                withIdentifier: "momentImageContent"
            ) as? MomentImageContentViewController,
            currentVC.getIndex() != 0
        else {
            return nil
        }
        
        let newIndex = currentVC.getIndex() - 1
        momentImageContentVC.setup(imageData: images[newIndex], index: newIndex)
        
        return momentImageContentVC
    }
    
    /// Pre-load next page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let currentVC = viewController as? MomentImageContentViewController,
            let momentImageContentVC = storyboard?.instantiateViewController(
                withIdentifier: "momentImageContent"
            ) as? MomentImageContentViewController,
            currentVC.getIndex() < images.count - 1
        else {
            return nil
        }

        let newIndex = currentVC.getIndex() + 1
        momentImageContentVC.setup(imageData: images[newIndex], index: newIndex)
        
        return momentImageContentVC
    }
    
    /// Sync `currentImageIndex` to the actual index. Used to update title in navbar
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            completed,
            let currentVC = pageViewController.viewControllers?.first as? MomentImageContentViewController
        else {
            return
        }
        
        self.currentImageIndex = currentVC.getIndex()
        updateNavBarTitle()
    }
}
