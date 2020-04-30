//
//  PageController.swift
//  PageController
//
//  Created by jingjun on 2020/4/28.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class PageController: UIViewController {
    
    private lazy var pageController : UIPageViewController = {
        let backview = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        backview.delegate = self
        backview.dataSource = self
        return backview
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private var pages : [UIViewController]
    private var currentIndex: Int = 0
    private var imgUrls: [String] = []
    
    private var bannerClickBlock: ((_ index: Int) -> Void)?
    private var timer: Timer?
    private var handTimer: Timer?
    private var imgIndex: Int = 0
    private var nextImgIndex: Int = 0
    var timeInterveal: Double = 3
    init() {
        self.pages = [
            ContentViewController.init(),
            ContentViewController.init(),
            ContentViewController.init()
        ]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        addTapAction()
    }
    
    func setUI() {
        self.addChild(pageController)
        pageController.didMove(toParent: self)
        self.view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    public func showBanner(imgUrl: [String],bannerClick: ((_ index: Int) -> Void)?) {
        guard imgUrl.count > 0 else {
            return
        }
        let enabel = imgUrl.count == 1 ? false : true
        self.setScrollEnabled(enabel)
        self.imgUrls = imgUrl
        self.bannerClickBlock = bannerClick
        self.pageControl.numberOfPages = imgUrl.count
        let current = pages[0] as! ContentViewController
        current.label.text = self.imgUrls[self.imgIndex]
        pageController.setViewControllers([current], direction: .forward, animated: true) { [weak self](finish) in
            guard let `self` = self else { return }
            self.currentIndex += 1
            
            self.nextImgIndex = self.imgIndex + 1
            if self.nextImgIndex >= self.imgUrls.count {
                self.nextImgIndex = 0
            }
            self.pageControl.currentPage = self.imgIndex
            
            let onController = self.pages[2] as! ContentViewController
            onController.label.text = self.imgUrls.last
            
            let nextController = self.pages[self.currentIndex] as! ContentViewController
            nextController.label.text = self.imgUrls[self.nextImgIndex]
        }
        // 如果图片个数大于1，开始轮播
        guard self.imgUrls.count > 1 else{
            return
        }
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterveal, repeats: true, block: { [weak self](timer) in
            
            self?.repeatAction()
        })
    }
    
    func repeatAction() {
        let controller = self.pages[self.currentIndex]
        self.setPageControllerShow(current: controller)
    }
    
    func setPageControllerShow(current: UIViewController) {
        
        let index = self.index(controller: current)
        
        if index >= pages.count || index == NSNotFound {
            return
        }
        
        pageController.setViewControllers([current], direction: .forward, animated: true) { [weak self](finish) in
            guard let `self` = self else { return }
            if index == 0 {
                self.currentIndex = 1
            }else if index == 1{
                self.currentIndex = 2
            }else{
                self.currentIndex = 0
            }
            self.imgIndex += 1
            
            self.nextImgIndex = self.imgIndex + 1
            
            if self.imgIndex >= self.imgUrls.count {
                self.imgIndex = 0
                self.nextImgIndex = self.imgIndex + 1
                self.pageControl.currentPage = self.imgIndex
            }else if self.nextImgIndex >= self.imgUrls.count {
                self.imgIndex = -1
                self.nextImgIndex = 0
                self.pageControl.currentPage = self.imgUrls.count - 1
            }else{
                self.pageControl.currentPage = self.imgIndex
            }
            
            let nextController = self.pages[self.currentIndex] as! ContentViewController
            nextController.label.text = self.imgUrls[self.nextImgIndex]
        }
    }
    
    private func setScrollEnabled(_ enable: Bool) {
        for subview in self.pageController.view.subviews {
            if subview.isKind(of: UIScrollView.self) {
                let scroll = subview as! UIScrollView
                scroll.isScrollEnabled = enable
            }
        }
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
        self.invalidatedHandTimer()
    }
}

extension PageController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getBeforeController(vc: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.getAfterController(vc: viewController)
    }
    
    // 获取到下一个控制器的索引
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.timer?.fireDate = .distantFuture
        self.invalidatedHandTimer()
    }
    // 完成动画
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            self.createHandTimer()
            return
        }
        // 之前的控制器
        let previous = previousViewControllers.first as! ContentViewController
        // 当前控制器
        let nowVC = pageViewController.viewControllers?.first as! ContentViewController
        let previousIndex = self.index(controller: previous)
        let nowVCIndex = self.index(controller: nowVC)
        
        if nowVCIndex >= pages.count || nowVCIndex == NSNotFound {
            return
        }
        
        if self.imgIndex == -1 {
            self.imgIndex = self.imgUrls.count - 1
        }
        
        if nowVCIndex == 2 && previousIndex == 0 { // 向后
            self.imgIndex -= 1
        }else if nowVCIndex == 0 && previousIndex == 2 { // 向前
            self.imgIndex += 1
        }else{
            if nowVCIndex > previousIndex { // 向前
                self.imgIndex += 1
            }else{ // 向后
                self.imgIndex -= 1
            }
        }
        
        
        let onIndex : Int
        if nowVCIndex == 0 {
            self.currentIndex = 1
            onIndex = 2
        }else if nowVCIndex == 1{
            self.currentIndex = 2
            onIndex = 0
        }else{
            self.currentIndex = 0
            onIndex = 1
        }
        
        let onImgIndex: Int
        let nextImgIndex: Int
        if self.imgIndex >= self.imgUrls.count {
            self.imgIndex = 0
            onImgIndex = self.imgUrls.count - 1
            nextImgIndex = self.imgIndex + 1
        }else if self.imgIndex == -1 {
            self.imgIndex = self.imgUrls.count - 1
            onImgIndex = self.imgIndex - 1
            nextImgIndex = 0
        }else if self.imgIndex == self.imgUrls.count - 1 {
            onImgIndex = self.imgIndex - 1
            nextImgIndex = 0
        }else if self.imgIndex == 0 {
            onImgIndex = self.imgUrls.count - 1
            nextImgIndex = self.imgIndex + 1
        }else{
            onImgIndex = self.imgIndex - 1
            nextImgIndex = self.imgIndex + 1
        }
        
        let onController = self.pages[onIndex] as! ContentViewController
        onController.label.text = self.imgUrls[onImgIndex]
        let nextController = self.pages[self.currentIndex] as! ContentViewController
        nextController.label.text = self.imgUrls[nextImgIndex]
        
        self.pageControl.currentPage = self.imgIndex
        self.createHandTimer()
        
    }
    
    
    public func index(controller: UIViewController?) -> Int {
        var index = 0
        for page in pages {
            if controller == page {
                break
            }
            index += 1
        }
        return index
    }
    
}

extension PageController {
    func createHandTimer() {
        self.handTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self](timer) in
            self?.timer?.fireDate = .distantPast // banner timer 开启
        })
    }
    
    func invalidatedHandTimer() {
        self.handTimer?.invalidate()
        self.handTimer = nil
    }
    
    
    func addTapAction() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickAction))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        pageController.view.isUserInteractionEnabled = true
        pageController.view.addGestureRecognizer(tap)
    }
    
    @objc func clickAction() {
        var index = self.imgIndex
        if self.imgIndex == -1 {
            index = self.imgUrls.count - 1
        }
        self.bannerClickBlock?(index)
    }
    
    private func getBeforeController(vc: UIViewController) -> UIViewController {
        let index = self.index(controller: vc)
        if index == 2 {
            return pages[1]
        }else if index == 1{
            return pages[0]
        }else{
            return pages[2]
        }
    }
    
    private func getAfterController(vc: UIViewController) -> UIViewController {
        let index = self.index(controller: vc)
        if index == 2 {
            return pages[0]
        }else if index == 1{
            return pages[2]
        }else{
            return pages[1]
        }
    }
}
