//
//  SageruContent.swift
//  Sageru
//
//  Created by ArakiKenta on 2016/11/08.
//  Copyright © 2016年 Araki Kenta. All rights reserved.
//

import UIKit

open class SageruContent {
    open var title: String?
    open var image: UIImage?
    open var completion: (() -> Void)?
    
    init() {}
    
    public convenience init(title: String, image:UIImage? = nil, completion: (() -> Void)? = nil) {
        self.init()
        self.title = title
        self.image = image
        self.completion = completion
    }
}
