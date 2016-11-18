//
//  NavigationController.swift
//  Sageru
//
//  Created by ArakiKenta on 2016/11/06.
//  Copyright © 2016年 Araki Kenta. All rights reserved.
//

import UIKit
import Sageru

class NavigationController: UINavigationController {

    var sageru: Sageru?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let top = storyboard.instantiateViewController(withIdentifier: "One") as! OneViewController
        setViewControllers([top], animated: false)
        
        let home = SageruContent(title: "Home", image: UIImage(named: "home")!, completion: {
            let homeC = storyboard.instantiateViewController(withIdentifier: "One") as! OneViewController
            self.setViewControllers([homeC], animated: false)
        })
        
        let music = SageruContent(title: "Music", image: UIImage(named: "disc")!, completion: {
            let musicC = storyboard.instantiateViewController(withIdentifier: "Two") as! TwoViewController
            self.setViewControllers([musicC], animated: false)
        })
        
        let favorite = SageruContent(title: "Favorite", image: UIImage(named: "favorite")!, completion: {
            let favoriteC = storyboard.instantiateViewController(withIdentifier: "Three") as! ThreeViewController
            self.setViewControllers([favoriteC], animated: false)
        })
        
        let local = SageruContent(title: "Local", image: UIImage(named: "folder")!, completion: {
            let localC = storyboard.instantiateViewController(withIdentifier: "Four") as! FourViewController
            self.setViewControllers([localC], animated: false)
        })
        
        let user = SageruContent(title: "User", image: UIImage(named: "user")!, completion: {
            let userC = storyboard.instantiateViewController(withIdentifier: "Five") as! FiveViewController
            self.setViewControllers([userC], animated: false)
        })

        sageru = Sageru(contents: [home, music, favorite, local, user], parentController: self)
        sageru?.backgroundImage = UIImage(named: "backImage")
        sageru?.cellBottomLineEnable = false
        sageru?.delegate = self
        sageru?.badges = [
            Badge(cellIndex: 3, count: 50),
            Badge(cellIndex: 4, count: 100)
        ]
    }
    
    func showMenu() {
        sageru?.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NavigationController: SageruDelegate {
    
    func didChangeSageruState(sageru: Sageru, state: SageruState) {
        switch state {
        case .shown:
            self.childViewControllers[0].navigationItem.rightBarButtonItem?.image = UIImage(named: "hat")
        case .closed:
            self.childViewControllers[0].navigationItem.rightBarButtonItem?.image = UIImage(named: "hamburger")
        default:
            return
        }
    }
    
    func didSelectCell(tableView: UITableView, indexPath: IndexPath) {
        print("select cell index row:", indexPath.row)
    }
}
