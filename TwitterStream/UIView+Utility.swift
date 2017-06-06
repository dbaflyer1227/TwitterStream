//
//  UIView+Utility.swift
//  TwitterStream
//
//  Created by dsailer on 4/24/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addPrettyBorderWith (radius:CGFloat, borderWidth:CGFloat) {
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
}
