//
//  ViewController.swift
//  Sageru
//
//  Created by ArakiKenta on 2016/11/06.
//  Copyright © 2016年 Araki Kenta. All rights reserved.
//

import UIKit

extension UIViewController {
    func setMenuAndTitle(titleText: String, color: UIColor, image: UIImage = UIImage(named: "hamburger")!) {
        let item = UIBarButtonItem(
            image: image,
            style: .plain,
            target: navigationController,
            action: #selector(NavigationController.showMenu)
        )
        item.tintColor = color
        self.navigationItem.rightBarButtonItem = item
        
        let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-Light", size: 16)!
        title.textColor = color
        title.text = titleText
        title.sizeToFit()
        self.navigationItem.titleView = title
    }
}
