//
//  ContentViewController.swift
//  PageController
//
//  Created by jingjun on 2020/4/28.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    lazy var imageview : UIImageView = {
        let image = UIImageView()
        return image
    }()

    lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = ""
        return label
    }()
    
    let colors: [UIColor] = [.red, .yellow, .blue, .green, .gray]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = self.colors.randomElement() ?? .red
        self.view.addSubview(self.imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

}
