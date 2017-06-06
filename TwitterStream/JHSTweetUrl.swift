//
//  JHSTweetUrl.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

import Gloss

class JHSTweetUrl: Decodable {

    var displayUrl: String?
    var url: String?
    
    required init(json: JSON) {

        self.displayUrl = "display_url" <~~ json
        self.url = "url" <~~ json
    }

}
