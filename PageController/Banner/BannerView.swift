//
//  BannerView.swift
//  PageController
//
//  Created by jingjun on 2020/4/30.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class BannerView: UIView {

    private lazy var controller: PageController = {
        let controller = PageController.init()
        return controller
    }()
    
    
    
    init(timeInterveal: Double) {
        super.init(frame: .zero)
        controller.timeInterveal = timeInterveal
        setUI()
    }
    
    func setUI() {
        self.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func showImgUrls(urls: [String],click: @escaping ((Int) -> Void)) {
        controller.showBanner(imgUrl: urls, bannerClick: click)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
