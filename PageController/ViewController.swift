//
//  ViewController.swift
//  PageController
//
//  Created by jingjun on 2020/4/28.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    lazy var tableview: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private var dataSource: [String] = ["无限轮播Banner","仿JD分类页面","左右滑动分页"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "UIPageViewController的使用Demo"
        setTableview()
    }
    
    func setTableview() {
        self.view.addSubview(self.tableview)
        self.tableview.frame = self.view.frame
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setBanner() {
        // 模拟数据
        var urls : [String] = []
        for i in 0 ..< 10 {
            let str = "图片 \(i)"
            urls.append(str)
        }
        
        let bannerView = BannerView(timeInterveal: 3)
        bannerView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 300)
        self.view.addSubview(bannerView)
        bannerView.showImgUrls(urls: urls) { (index) in
            print(index)
        }
    }
}

extension ViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = BannerController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let VC = JDPageController()
            self.navigationController?.pushViewController(VC, animated: true)
        case 2:
            let pages = [
                ColorViewController.init(color: .gray),
                ColorViewController.init(color: .green),
                ColorViewController.init(color: .blue)
            ]
            let vc = PageDemoViewController.init(pages: pages, defaultIndex: 0)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}
