//
//  PageRefresh.swift
//  PageController
//
//  Created by jingjun on 2020/5/5.
//  Copyright © 2020 jingjun. All rights reserved.
//

import Foundation

class PageRefreshHeader : MJRefreshHeader {
    
    private lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func prepare() {
        super.prepare()
        self.mj_h = 100
        self.addSubview(label)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.label.frame = CGRect(x: 0, y: 50, width: ScreenW - 80, height: 50)
    }
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewPanStateDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                self.label.text = "下拉继续浏览"
            default:
                self.label.text = "下拉继续浏览"
            }
        }
    }
    
}

class PageRefreshFooter : MJRefreshBackFooter  {
    private lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func prepare() {
        super.prepare()
        self.mj_h = 80
        self.addSubview(label)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.label.frame = CGRect(x: 0, y: 0, width: ScreenW, height: 50)
    }
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewPanStateDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                self.label.text = ""
            default:
                self.label.text = ""
            }
        }
    }
}
