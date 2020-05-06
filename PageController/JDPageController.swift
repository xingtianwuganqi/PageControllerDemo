//
//  JDPageController.swift
//  PageController
//
//  Created by jingjun on 2020/5/5.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class JDPageController: UIViewController {
    

    lazy var tableview: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
    
    private lazy var pageController : UIPageViewController = {
        let backview = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.vertical, options: nil)
        backview.delegate = self
        backview.dataSource = self
        return backview
    }()
    private var pages : [UIViewController] = []
    
    private var dataSource: [String] = ["第0行","第1行","第2行","第3行","第4行","第5行","第6行","第7行","第8行","第9行"]
    
    private var didSelectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setTableview()
        setPageController()
        setPages()
    }
    
    func setPages() {
        self.pages = self.dataSource.enumerated().map({ (index,str) -> JDColldectionController in
            let vc = JDColldectionController()
            vc.delegate = self
            if index == 0 {
                vc.hiddenHeader = true
            }
            if index == self.dataSource.count - 1{
                vc.hiddenFooter = true
            }
            return vc
        })
        showSelectPage(index: 0)
    }
    
    func setTableview() {
        self.view.addSubview(self.tableview)
        self.tableview.frame = CGRect(x: 0, y: 0, width: 80, height: ScreenH)
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
    }
    
    func setPageController() {
        self.addChild(pageController)
        self.didMove(toParent: pageController)
        self.view.addSubview(pageController.view)
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageController.view.leadingAnchor.constraint(equalTo: self.tableview.trailingAnchor).isActive = true
        pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.setScrollEnabled(false)
    }
    
    func showSelectPage(index: Int) {
        let controller = self.pages[index]
        
        let direction: UIPageViewController.NavigationDirection
        let animation: Bool
        if index > self.didSelectIndex {
            direction = .forward
            animation = true
        }else if index < self.didSelectIndex{
            direction = .reverse
            animation = true

        }else{
            direction = .forward
            animation = false
        }
        
        self.pageController.setViewControllers([controller], direction: direction, animated: animation) { [weak self](finish) in
            guard let `self` = self else { return }
            if finish {
                self.didSelectIndex = index
            }
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
}

extension JDPageController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.showSelectPage(index: indexPath.row)
    }
}

extension JDPageController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        var index = self.index(controller: viewController)
//        if index == 0 || index == NSNotFound {
//            return nil
//        }
//
//        index -= 1
//        if self.pages.count > index {
//            return self.pages[index]
//        }else{
//            return nil
//        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
//        var index = self.index(controller: viewController)
//        if index == NSNotFound {
//            return nil
//        }
//
//        index += 1
//        if self.pages.count > index {
//            return self.pages[index]
//        }else{
//            return nil
//        }
        return nil
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

extension JDPageController: PageDetailDelegate {
    func pullTopAction() {
        guard let current = self.pageController.viewControllers?.first else {
            return
        }
        var index = self.index(controller: current)
        if index == 0 || index == NSNotFound {
            return
        }

        index -= 1
        if self.pages.count > index {
            self.showSelectPage(index: index)
        }
    }
    
    func pullBottomAction() {
        guard let current = self.pageController.viewControllers?.first else {
            return
        }
        var index = self.index(controller: current)
        if index == NSNotFound {
            return
        }

        index += 1
        if self.pages.count > index {
            self.showSelectPage(index: index)
        }
    }
}
