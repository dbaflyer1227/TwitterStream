//
//  JHSEmoji.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

import Gloss

class JHSEmoji : Decodable {
    
    var name: String?
    var unified: String?
    
    required init(json: JSON) {
        
        self.name = "name" <~~ json
        self.unified = "unified" <~~ json
    }

}
