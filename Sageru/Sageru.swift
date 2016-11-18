//
//  Sageru.swift
//  Sageru
//
//  Created by ArakiKenta on 2016/11/06.
//  Copyright © 2016年 Araki Kenta. All rights reserved.
//

import UIKit

// MARK: - SageruDelegate -
public protocol SageruDelegate: NSObjectProtocol {
    func didChangeSageruState(sageru: Sageru, state: SageruState)
    func didSelectCell(tableView: UITableView, indexPath: IndexPath)
}

// MARK: - State and Enums -
public enum SageruState {
    case shown
    case closed
    case pulling
}

fileprivate struct SageruColor {
    static let white  = UIColor.rgb(r: 250, g: 250, b: 250, alpha: 1)
    static let black  = UIColor.rgb(r: 10, g: 10, b: 10, alpha: 1)
    static let orange = UIColor.rgb(r: 231, g: 114, b: 48, alpha: 1)
}

public struct Badge {
    public var cellIndex: Int = 0
    public var count: Int = 0
    public init(cellIndex: Int, count: Int) {
        self.cellIndex = cellIndex
        self.count = count
    }
}

open class Sageru: UIView {
    
    // MARK: - fileprivate settings -
    fileprivate let startIndex = 1
    fileprivate var currentState: SageruState = .closed {
        didSet {
            self.delegate?.didChangeSageruState(sageru: self, state: currentState)
        }
    }
    fileprivate var contentController: UIViewController?
    fileprivate var screenHeight: CGFloat = UIScreen.main.bounds.height
    fileprivate var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    fileprivate var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    // MARK: - open settings -
    // delegate
    weak open var delegate: SageruDelegate?
    
    // authorization
    open var panGestureEnable = true
    open var cellBottomLineEnable = true
    
    // color
    open var textColor: UIColor = SageruColor.white
    open var menuBackgroundColor: UIColor = SageruColor.black
    open var selectCellLineColor: UIColor = SageruColor.orange
    
    // font
    open var titleFont: UIFont = UIFont(name: "HelveticaNeue-Light", size: 18)!
    
    open var bounceOffset: CGFloat = 0
    open var animationDuration: TimeInterval = 0.3
    
    // table and cell
    open var sageruTableView: UITableView?
    open var selectedIndex: Int = 1
    open var cellHeight: CGFloat = 40
    open var headerHeight: CGFloat = 30
    
    open var contents: [SageruContent] = []
    
    open var backgroundImage: UIImage? {
        didSet {
            backImageView.image = backgroundImage
        }
    }
    open var height: CGFloat = 400 {
        didSet {
            frame.size.height = height
            sageruTableView?.frame = frame
        }
    }
    override open var backgroundColor: UIColor? {
        didSet {
            UIApplication.shared.delegate?.window??.backgroundColor = backgroundColor
        }
    }
    
    open var badges: [Badge] = [Badge(cellIndex:0, count:0)]
    
    // MARK: - initialize -
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(contents: [SageruContent], parentController: UIViewController) {
        self.init()
        self.contents = contents
        height = screenHeight - 80
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        contentController = parentController
        
        sageruTableView = UITableView(frame: frame)
        sageruTableView?.delegate = self
        sageruTableView?.dataSource = self
        sageruTableView?.showsVerticalScrollIndicator = false
        sageruTableView?.separatorColor = UIColor.clear
        sageruTableView?.backgroundColor = UIColor.clear
        addSubview(backImageView)
        addSubview(sageruTableView!)
    
        if panGestureEnable {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(Sageru.panGestureEvent(on:)))
            contentController?.view.addGestureRecognizer(panGesture)
        }
        
        UIApplication.shared.delegate?.window??.rootViewController = contentController
        UIApplication.shared.delegate?.window??.insertSubview(self, at: 0)
        UIApplication.shared.delegate?.window??.backgroundColor = menuBackgroundColor
    }
    
    open override func layoutSubviews() {
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        backImageView.frame = frame
        sageruTableView?.frame = frame
        contentController?.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    open func show() {
        switch currentState {
        case .shown, .pulling:
            close()
        case .closed:
            open()
        }
    }
    
    open func panGestureEvent(on panGesture: UIPanGestureRecognizer) {
        
        if !panGestureEnable {
            return
        }
        
        guard
            let panView = panGesture.view,
            let parentPanView = panView.superview,
            var viewCenter = panGesture.view?.center,
            let contentController = contentController
            else { return }
        
        if panGesture.state == .began || panGesture.state == .changed {
            let translation = panGesture.translation(in: parentPanView)
            
            if viewCenter.y >= screenHeight/2
                && viewCenter.y <= (screenHeight/2 + height) - bounceOffset {
                currentState = .pulling
                viewCenter.y = abs(viewCenter.y + translation.y)
                
                if viewCenter.y >= screenHeight/2
                    && viewCenter.y <= (screenHeight/2 + height) - bounceOffset {
                    contentController.view.center = viewCenter
                }
                
                panGesture.setTranslation(CGPoint.zero, in: contentController.view)
            }
            
        } else if panGesture.state == .ended {
            if viewCenter.y > contentController.view.frame.size.height {
                open()
            } else {
                close()
            }
        }
    }
    
    fileprivate func open(animated: Bool = true, completion: (() -> Void)? = nil) {
        if currentState == .shown {
            return
        }
        
        guard let x = contentController?.view.center.x else {
            return
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.contentController?.view.center = CGPoint(x: x, y: self.screenHeight/2 + self.height)
            }, completion: { _ in
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.contentController?.view.center = CGPoint(x: x, y: self.screenHeight/2 + self.height - self.bounceOffset)
                }, completion: { _ in
                    self.currentState = .shown
                    completion?()
                })
            })
        } else {
            contentController?.view.center = CGPoint(x: x, y: screenHeight/2 + height)
            currentState = .shown
            completion?()
        }
    }
    
    fileprivate func close(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let center = contentController?.view.center else {
            return
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.contentController?.view.center = CGPoint(x: center.x, y: center.y + self.bounceOffset)
            }, completion: { _ in
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.contentController?.view.center = CGPoint(x: center.x, y: self.screenHeight/2)
                }, completion: { _ in
                    self.currentState = .closed
                    completion?()
                })
            })
        } else {
            contentController?.view.center = CGPoint(x: center.x, y: screenHeight/2)
            currentState = .closed
            completion?()
        }
    }
}

// MARK: - SageruTableView DataSource and Delegate -
extension Sageru: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = SageruTableViewCell(style: .default, reuseIdentifier: "SageruCell")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.titleLabel.textColor = textColor
        cell.selectLine.backgroundColor = selectedIndex == indexPath.row ? selectCellLineColor : UIColor.clear
        cell.titleLabel.font = titleFont
        cell.textLabel?.textAlignment = .left
        
        if !cellBottomLineEnable {
            cell.bottomLine.backgroundColor = UIColor.clear
        }
        
        let content: SageruContent?
        
        if indexPath.row >= startIndex && indexPath.row <= (contents.count - 1 + startIndex) {
            content = contents[indexPath.row - startIndex]
            cell.titleLabel.text = content?.title
            cell.cellImage.image = content?.image?.withRenderingMode(.alwaysTemplate)
        }
        
        for badge in badges {
            if badge.cellIndex == indexPath.row {
                cell.setBadgeValue(value: badge.count)
            }
        }
        return cell
    }
}

extension Sageru: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < startIndex || indexPath.row > contents.count - 1 + startIndex {
            return
        }
        selectedIndex = indexPath.row
        tableView.reloadData()
        let selectedItem = contents[indexPath.row - startIndex]
        self.delegate?.didSelectCell(tableView: tableView, indexPath: indexPath)
        close(completion: selectedItem.completion)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

// MARK: - Extention UIColor RGB -
extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

// MARK: - Extention UINavigationBar sizeThatFits -
extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.center = CGPoint(x: self.center.x, y: self.frame.height-2)
        return CGSize(width: UIScreen.main.bounds.size.width, height: 44)
    }
}
