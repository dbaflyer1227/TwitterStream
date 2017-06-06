//
//  JHSButtonStandard.swift
//  TwitterStream
//
//  Created by dsailer on 4/29/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import UIKit

class JHSButtonRoundBordered: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
    
}
