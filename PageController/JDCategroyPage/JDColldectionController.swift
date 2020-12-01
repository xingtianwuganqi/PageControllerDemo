//
//  JDColldectionController.swift
//  PageController
//
//  Created by jingjun on 2020/5/5.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

enum scrollState: Int {
    case top = 0
    case bottom
    case center
}

protocol PageDetailDelegate: NSObjectProtocol {
    func pullTopAction()
    func pullBottomAction()
}

class JDColldectionController: UIViewController {
    
    weak var delegate: PageDetailDelegate?

    lazy var tableview: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
    
    private var dataSource: [String] = []
    private var lastPosition: CGFloat?
    private var scrollState: scrollState = .top
    
    var hiddenHeader: Bool = false
    var hiddenFooter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableview()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func setTableview() {
        self.view.addSubview(self.tableview)
        self.tableview.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.tableview.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 64).isActive = true
        }
        self.tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        
        self.tableview.mj_header = PageRefreshHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        self.tableview.mj_footer = PageRefreshFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
        
        if self.hiddenHeader {
            self.tableview.mj_header?.isHidden = true
        }
        
        if self.hiddenFooter {
            self.tableview.mj_footer?.isHidden = true
        }
    }
    
    func setDataSource() {
        for i in 0 ..< 20 {
            self.dataSource.append("第\(i)行")
        }
        self.dataSource.append("上拉继续浏览")
        self.tableview.reloadData()
    }

    @objc func headerRefresh() {
        delegate?.pullTopAction()
        self.tableview.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        delegate?.pullBottomAction()
        self.tableview.mj_footer?.endRefreshing()
    }
    
    
}

extension JDColldectionController : UITableViewDataSource,UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        /*
//         int currentPostion = scrollView.contentOffset.y;
//         if (currentPostion - _lastPosition > 25) {
//             _lastPosition = currentPostion;
//             NSLog(@"ScrollUp now");
//         }
//         else if (_lastPosition - currentPostion > 25)
//         {
//             _lastPosition = currentPostion;
//             NSLog(@"ScrollDown now");
//         }
//         */
//        let currentPostion = scrollView.contentOffset.y
//        var isDown: Bool = false
//        if currentPostion < lastPosition ?? 0 {
//            print("Down    ","scrollContentOffset.y:",currentPostion)
//            isDown = true
//
////            if scrollState == .bottom {
////                scrollState = .center
//////                self.tableview.isScrollEnabled = true
////            }
//        }else if currentPostion > lastPosition ?? 0 {
//            print("UP    ","scrollContentOffset.y:",currentPostion)
////            isDown = false
////            if scrollState == .top {
////                scrollState = .center
//////                self.tableview.isScrollEnabled = true
////            }
//        }
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastPosition = scrollView.contentOffset.y
        
    }
    
    
    
}
