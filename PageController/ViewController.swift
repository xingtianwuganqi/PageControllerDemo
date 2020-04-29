//
//  ViewController.swift
//  PageController
//
//  Created by jingjun on 2020/4/28.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let page = PageController.init()
        self.present(page, animated: true, completion: nil)
    }
}

