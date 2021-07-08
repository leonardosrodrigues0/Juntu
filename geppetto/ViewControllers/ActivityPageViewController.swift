//
//  ActivityPageViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit

class ActivityPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Override func to remove bottom border from page controller.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let subViews: NSArray = view.subviews as NSArray
        var scrollView: UIScrollView? = nil
        var pageControl: UIPageControl? = nil

        for view in subViews {
            if (view as AnyObject).isKind(of: UIScrollView.self) {
                scrollView = view as? UIScrollView
            } else if (view as AnyObject).isKind(of: UIPageControl.self) {
                pageControl = view as? UIPageControl
            }
        }

        if (scrollView != nil && pageControl != nil) {
            scrollView?.frame = view.bounds
            view.bringSubviewToFront(pageControl!)
        }
    }
    
}
