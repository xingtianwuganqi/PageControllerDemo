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
    
    private var pages : [UIViewController]
    private var currentIndex: Int = 0
    private var imgUrls: [String]?
    private var imgs: [UIImage]?
    
    private var bannerClickBlock: ((_ index: Int) -> Void)?
    private var timer: Timer?
    private var handTimer: Timer?
    private var nums: [String] = []
    private var imgIndex: Int = 0
    private var nextImgIndex: Int = 0
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
        
        // 模拟数据
        var urls : [String] = []
        for i in 0 ..< 20 {
            let str = "图片 \(i)"
            urls.append(str)
        }
        
        showBanner(imgUrl: urls, bannerClick: nil)
    }
    
    func setUI() {
        self.addChild(pageController)
        pageController.didMove(toParent: self)
        self.view.addSubview(pageController.view)
        pageController.view.frame = self.view.frame
        
        
    }
    
    func showBanner(imgUrl: [String],bannerClick: ((_ index: Int) -> Void)?) {
        self.imgUrls = imgUrl
        self.bannerClickBlock = bannerClick
        
        let current = pages[0] as! ContentViewController
        current.label.text = self.imgUrls?[self.imgIndex]
        pageController.setViewControllers([current], direction: .forward, animated: true) { (finish) in
            self.currentIndex += 1
//            self.imgIndex
            self.nextImgIndex += self.imgIndex + 1
            if self.nextImgIndex >= self.imgUrls?.count ?? 0 {
                self.nextImgIndex = 0
            }
            let nextController = self.pages[self.currentIndex] as! ContentViewController
            nextController.label.text = self.imgUrls?[self.nextImgIndex]
        }
        guard self.imgUrls?.count ?? 0 > 1 else{
//            pageController.
            return
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self](timer) in

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
        
        pageController.setViewControllers([current], direction: .forward, animated: true) { (finish) in
            if index == 0 {
                self.currentIndex = 1
            }else if index == 1{
                self.currentIndex = 2
            }else{
                self.currentIndex = 0
            }
            self.imgIndex += 1
            self.nextImgIndex = self.imgIndex + 1
            if self.nextImgIndex >= self.imgUrls?.count ?? 0 {
                self.nextImgIndex = 0
            }
            let nextController = self.pages[self.currentIndex] as! ContentViewController
            nextController.label.text = self.imgUrls?[self.nextImgIndex]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
        self.invalidatedHandTimer()
    }
}

extension PageController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.index(controller: viewController)
        if index == 2 {
            return pages[1]
        }else if index == 1{
            return pages[0]
        }else{
            return pages[2]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.index(controller: viewController)
    
        if index == 2 {
            return pages[0]
        }else if index == 1{
            return pages[2]
        }else{
            return pages[1]
        }
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
        
        if nowVCIndex == 2 && previousIndex == 0 { // 向后
            print("向后")
            self.imgIndex -= 1
        }else if nowVCIndex == 0 && previousIndex == 2 { // 向前
            print("向前")
            self.imgIndex += 1
        }else{
            if nowVCIndex > previousIndex { // 向前
                print("向前")
                self.imgIndex += 1
            }else{ // 向后
                print("向后")
                self.imgIndex -= 1
            }
        }
        
        
        if nowVCIndex >= pages.count || nowVCIndex == NSNotFound {
            return
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
        if self.imgIndex >= self.imgUrls?.count ?? 0 {
            self.imgIndex = 0
            onImgIndex = (self.imgUrls?.count ?? 1) - 1
            nextImgIndex = self.imgIndex + 1
        }else if self.imgIndex == -1 {
            self.imgIndex = (self.imgUrls?.count ?? 1) - 1
            onImgIndex = self.imgIndex - 1
            nextImgIndex = 0
        }else if self.imgIndex == (self.imgUrls?.count ?? 0) - 1 {
            onImgIndex = self.imgIndex - 1
            nextImgIndex = 0
        }
        else{
            if self.imgIndex == 0 {
                onImgIndex = (self.imgUrls?.count ?? 1) - 1
                nextImgIndex = self.imgIndex + 1
            }else{
                onImgIndex = self.imgIndex - 1
                nextImgIndex = self.imgIndex + 1
            }
        }
        
        let onController = self.pages[onIndex] as! ContentViewController
        onController.label.text = self.imgUrls?[onImgIndex]
        
        let nextController = self.pages[self.currentIndex] as! ContentViewController
        nextController.label.text = self.imgUrls?[nextImgIndex]
                
        print("previousIndex:",previousIndex,"nowVCIndex: ",nowVCIndex)
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
    
    public func index(text: String) -> Int {
        var index = 0
        for str in nums {
            if text == str {
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
}
