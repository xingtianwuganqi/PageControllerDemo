//
//  LoacalNotificationController.swift
//  PageController
//
//  Created by jingjun on 2020/6/3.
//  Copyright © 2020 jingjun. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent.init()
        content.badge = 1
        content.title = "闹铃"
        content.body = "该起床啦"
        content.sound = .default
        var date = DateComponents.init()
        date.hour = 15
        date.minute = 43
        let tigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        let request = UNNotificationRequest.init(identifier: "request1", content: content, trigger: tigger)
        center.add(request) { (error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print("添加成功")
            }
        }
        center.requestAuthorization(options: [.alert,.sound,.badge]) { (finish, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print("finished")
            }
        }
    }

}
