//
//  File.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

import Gloss

class JHSTweetMedia: Decodable {

    var type: String
    var url: String?
    
    required init?(json: JSON) {
        
        guard let type: String = "type" <~~ json else {
            return nil;
        }
        
        self.type = type
        self.url = "url" <~~ json
    }

}
