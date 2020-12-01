//
//  ColorViewController.swift
//  PageController
//
//  Created by jingjun on 2020/12/1.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    var color: UIColor
    init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = color
    }
    

    
    

}
