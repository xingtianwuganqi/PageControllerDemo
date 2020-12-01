//
//  BannerController.swift
//  PageController
//
//  Created by jingjun on 2020/5/6.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class BannerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setBanner()
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
