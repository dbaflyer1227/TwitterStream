//
//  JHSTweet.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

import Gloss

class JHSTweet: Decodable {

    var text: String
    var source: String?
    var domainUrl: URL?
    var media: [JHSTweetMedia]?
    var hashTags: [JHSTweetHashTag]?
    var urls: [JHSTweetUrl]?

    required init?(json: JSON) {
        
        guard let text: String = "text" <~~ json else {
            return nil;
        }

        self.text = text
        self.source = "source" <~~ json
        self.domainUrl = "user.url" <~~ json
        self.urls = "entities.urls" <~~ json
        self.media = "entities.media" <~~ json
        self.hashTags = "entities.hashtags" <~~ json

    }
}
