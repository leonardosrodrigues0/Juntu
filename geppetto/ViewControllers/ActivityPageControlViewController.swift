//
//  ActivityPageControlViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit

/// Control of the PageViewController for a given activity
class ActivityPageControlViewController: UIViewController, CameraManager {
    
    // MARK: - Properties
    @IBOutlet weak var contentView: UIView!
    var currentViewControllerIndex = 0
    var activity: Activity?
    var dataSource: [ActivityStep] {
        return self.activity?.getSteps() ?? []
    }
    var helper = AnalyticsHelper.init()
    
    // MARK: - Page Control Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        helper = AnalyticsHelper.init()
        configurePageViewController()
    }
    
    /// Set options for pages
    func configurePageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ActivityPageViewController.self)) as? ActivityPageViewController else {
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        contentView.addSubview(pageViewController.view)

        // Remove borders from page view.
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }
    
    func detailViewControllerAt(index: Int) -> ActivityStepViewController? {
        guard index < dataSource.count && !dataSource.isEmpty else {
            return nil
        }
        
        guard let activityStepViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ActivityStepViewController.self)) as? ActivityStepViewController else {
            return nil
        }
        
        activityStepViewController.index = index
        activityStepViewController.step = dataSource[index]

        return activityStepViewController
    }
    
    // MARK: - Camera Usage Methods
    @IBAction private func cameraButtonTapped() {
        takePicture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let name = activity?.name else {
            return
        }
        
        let shareText = "Estou usando Juntu e fazendo a atividade \(name) com minha criança!"
        dismissPickerAndShareImageAndText(picker, didFinishPickingMediaWithInfo: info, text: shareText)
    }
    
}

extension ActivityPageControlViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let activityStepViewController = viewController as? ActivityStepViewController
        
        guard var currentIndex = activityStepViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            helper.logViewedFinalStep(activity: self.activity!)
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let activityStepViewController = viewController as? ActivityStepViewController
        
        guard var currentIndex = activityStepViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
}
