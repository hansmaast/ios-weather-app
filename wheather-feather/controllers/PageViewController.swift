

import UIKit


class PageViewController: UIViewController {
    
    private var pageController: UIPageViewController?
    
    private var pages: [UIViewController] = []
    private var currentIndex: Int = 0
    
    var data: CurrentLocationWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = CurrentLocationWeather.shared
        
        if let days = data?.forecastDaysWithStartingIndex {
            print("Total days: \(days.count)")
            for (i, day) in days.enumerated() {
                pages.append(HomeViewController(pageIndex: i, dayWithStartingIndex: day))
            }
            
            self.setupPageController()
        }
    }
    
    // This is a qwirky way of making sure the page view is at the staring index when view appears
    override func viewWillAppear(_ animated: Bool) {
        if pages.isEmpty {
            self.viewDidLoad()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        pages.removeAll()
    }
    
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        self.addChild(self.pageController!)
        let pageView = self.pageController!.view!
        self.view.addSubview(pageView)
        pageView.backgroundColor = .clear
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
        
        let initialVC = pages[0]
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? HomeViewController else {
            return nil
        }
        
        var index = currentVC.pageIndex
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc = pages[index]
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? HomeViewController else {
            return nil
        }
        
        var index = currentVC.pageIndex
        
        if index >= self.pages.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc = pages[index]
        
        return vc
    }
}

