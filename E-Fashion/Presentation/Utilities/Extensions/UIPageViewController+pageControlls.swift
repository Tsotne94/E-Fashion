//
//  UIPageViewController+pageControlls.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.01.25.
//
import UIKit

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
            guard let currentPage = viewControllers?[0] else { return }
            guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
            
            setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        }
        
        func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
            guard let currentPage = viewControllers?[0] else { return }
            guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
            
            setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
        }
        
        func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
            setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        }
}
