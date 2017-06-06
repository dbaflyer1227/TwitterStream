//
//  JHSTweetHashTag.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

import Gloss

class JHSTweetHashTag : Decodable {
    
    var text: String
    
    required init?(json: JSON) {
        
        guard let text: String = "text" <~~ json else {
            return nil;
        }
        
        self.text = text
    }

}
