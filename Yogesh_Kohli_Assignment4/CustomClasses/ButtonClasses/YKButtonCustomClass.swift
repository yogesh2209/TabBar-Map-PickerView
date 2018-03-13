//
//  YKButtonCustomClass.swift
//  Yogesh_Kohli_Assignment4
//
//  Created by Yogesh Kohli on 10/11/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class YKButtonCustomClass: UIButton {

    var myValue: Int
    
    @IBInspectable var setRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = setRadius
        }
    }
    @IBInspectable var setBorderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = setBorderColor.cgColor
        }
    }
    @IBInspectable var setBorderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = setBorderWidth
        }
    }
    required init?(coder SAButtonDecoder: NSCoder) {
        self.myValue = 0
        super.init(coder: SAButtonDecoder)
    }
}
