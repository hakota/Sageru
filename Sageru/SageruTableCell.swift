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
        return label
    }()
    
    open var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
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
    }
}
