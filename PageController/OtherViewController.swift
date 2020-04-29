//
//  OtherViewController.swift
//  PageController
//
//  Created by jingjun on 2020/4/28.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
