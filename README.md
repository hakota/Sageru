# Sageru

## Demo

![Sageru](https://github.com/hakota/Sageru/blob/master/sageru.gif)

## Installation

### CocoaPods

Add the following line in your Podfile.
```
pod "Sageru"
```

### Carthage

Add the following line to your Cartfile.

```
github "hakota/Sageru"
```
## Example

```
import UIKit
import Sageru

class NavigationController: UINavigationController {

    var sageru: Sageru?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let top = storyboard.instantiateViewController(withIdentifier: "One") as! OneViewController
        setViewControllers([top], animated: false)
        
        let one = SageruContent(title: "One", image: UIImage(named: "home")!, completion: {
            let homeC = storyboard.instantiateViewController(withIdentifier: "One") as! OneViewController
            self.setViewControllers([homeC], animated: false)
        })
        
        let two = SageruContent(title: "Two", image: UIImage(named: "disc")!, completion: {
            let musicC = storyboard.instantiateViewController(withIdentifier: "Two") as! TwoViewController
            self.setViewControllers([musicC], animated: false)
        })

        sageru = Sageru(contents: [one, two], parentController: self)
        sageru?.backgroundImage = UIImage(named: "backImage")
        sageru?.cellBottomLineEnable = false
        sageru?.delegate = self
        sageru?.badges = [
            Badge(cellIndex: 1, count: 50, badgePattern: .new),
            Badge(cellIndex: 2, count: 1000, badgePattern: .plus)
        ]
    }
    
    func showMenu() {
        sageru?.show()
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
```


## Licence

[MIT](https://github.com/hakota/Sageru/blob/master/LICENSE)

## Author

[hakota](https://github.com/hakota)
