//
//  ActivityPageViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit

/// Custom PageViewController for activity steps
class ActivityPageViewController: UIPageViewController {
    var activity: Activity?
    var pages = [UIViewController]()
    let initialPageIndex = 0
    
    let pageControl = UIPageControl()
    
    var helper = AnalyticsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        helper = AnalyticsHelper()
    }
    
    func setActivity(_ activity: Activity) {
        self.activity = activity
        
        instantiateStepPages()
    }
    
    private func instantiateStepPages() {
        let allSteps = getActivitySteps()
        
        pages = [UIViewController]()
        for i in 0..<allSteps.count {
            guard let activityStepVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ActivityStepViewController.self)) as? ActivityStepViewController else {
                return
            }

            activityStepVC.activity = activity
            activityStepVC.index = i
            activityStepVC.step = allSteps[i]
            pages.append(activityStepVC)
        }
        /// Adds conclusion screen
        guard let activityConclusionVC = UIStoryboard(name: "ActivityConclusion", bundle: .main).instantiateViewController(withIdentifier: "conclusion") as? ActivityConclusion else {
            return
        }
        pages.append(activityConclusionVC)
    }
    private func getActivitySteps() -> [ActivityStep] {
        return self.activity?.getSteps() ?? []
    }
    
    /// Override func to remove bottom border from page controller
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let subViews: NSArray = view.subviews as NSArray
        var scrollView: UIScrollView?
        var pageControl: UIPageControl?

        for view in subViews {
            if (view as AnyObject).isKind(of: UIScrollView.self) {
                scrollView = view as? UIScrollView
            } else if (view as AnyObject).isKind(of: UIPageControl.self) {
                pageControl = view as? UIPageControl
            }
        }

        if scrollView != nil && pageControl != nil {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
    }
    
}

extension ActivityPageViewController {
    func setup() {
        dataSource = self
        delegate = self
        
        guard initialPageIndex >= 0 && initialPageIndex < pages.count else {
            return
        }
        
        // set initial viewController to be displayed
        // Note: We are not passing in all the viewControllers here. Only the one to be displayed.
        setViewControllers([pages[initialPageIndex]], direction: .forward, animated: false, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .accentColor
        pageControl.pageIndicatorTintColor = .pageTintColor
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPageIndex
        
        // When pageControl value changes (direct click on pageControl), it calls pageControlSelectionAction
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .valueChanged)
    }
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        
        if page == self.pages.count - 1 {
            self.helper.logViewedFinalStep(activity: self.activity!)
        }
        
        setViewControllers([pages[page!]], direction: .forward, animated: false, completion: nil)
    }
    
    func layout() {
        // Remove borders
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1)
        ])
    }
}

// MARK: - DataSources

extension ActivityPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
        if currentIndex != 0 {
            return pages[currentIndex - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

// MARK: - Delegates

extension ActivityPageViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // IMPORTANT: without DispatchQueue.main.async, it cann crash if you swipe too fast
        DispatchQueue.main.async {
            guard let viewControllers = pageViewController.viewControllers else { return }
            guard let currentIndex = self.pages.firstIndex(of: viewControllers[0]) else { return }
            
            self.pageControl.currentPage = currentIndex
            
            // the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
            if completed && currentIndex == self.pages.count - 1 {
                self.helper.logViewedFinalStep(activity: self.activity!)
            }
        }
    }

}

// MARK: - Blocking Gestures

extension ActivityPageViewController {
    private func blockGestures(forSec: Double) {
        blockGestures()
        let seconds = forSec
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.unblockGestures()
        }
    }
    
    private func blockGestures() {
        // self.dataSource = nil
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func unblockGestures() {
        // dataSource = self
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }
}
