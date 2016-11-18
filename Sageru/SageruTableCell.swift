//
//  SageruTableCell.swift
//  Sageru
//
//  Created by ArakiKenta on 2016/11/08.
//  Copyright © 2016年 Araki Kenta. All rights reserved.
//

import UIKit

class SageruTableViewCell: UITableViewCell {
    
    open var selectLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    open var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)!
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    open var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    open var badge: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)!
        label.text = ""
        label.isHidden = true
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        return label
    }()

    var totalHeight: CGFloat!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(selectLine)
        contentView.addSubview(cellImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLine)
        contentView.addSubview(badge)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let maxX = self.frame.width
        let maxY = self.frame.height
        let margin: CGFloat = 4
        
        selectLine.frame = CGRect(x: margin, y: margin, width: 4, height: maxY-(margin*2))
        cellImage.frame  = CGRect(x: selectLine.frame.maxX + margin*2, y: margin*3, width: maxY-(margin*6), height: maxY-(margin*6))
        titleLabel.frame = CGRect(x: cellImage.frame.maxX + (margin*3), y: margin, width: maxX-(cellImage.frame.maxX + (margin*3)), height: maxY-(margin*2))
        bottomLine.frame = CGRect(x: margin*6, y: maxY-0.5, width: maxX-(margin*12), height: 0.5)
        badge.frame      = CGRect(x: titleLabel.frame.minX + (margin*3) + titleLabelToVary(label: titleLabel).width, y: 0, width: maxY/2, height: maxY/2)
        badge.center     = CGPoint(x: badge.center.x, y: titleLabel.center.y)
    }
    
    func setBadgeValue(value: Int) {
        if value <= 0 {
            badge.isHidden = true
            return
        }
        var count: String = String(value)
        if count.characters.count > 2 {
            badge.text = "N"
            badge.isHidden = false
            return
        }
        badge.text = count
        badge.isHidden = false
    }
    
    func titleLabelToVary(label: UILabel) -> CGSize {
        guard label.text != nil else {
            return CGSize(width: 0, height: 0)
        }
        let width = label.text?.size(attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18)!])
        return width!
    }
}
