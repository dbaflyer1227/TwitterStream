//
//  String+Emoji.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

extension String {
    
    func emojis() -> Array<String> {
        
        var emojis: Array<String> = Array<String>()
        
        let range = self.startIndex ..< self.endIndex
        let opts:NSString.EnumerationOptions = .byComposedCharacterSequences
        
        self.enumerateSubstrings(in: range, options: opts) {w,_,_,_ in
            
            guard let word = w else {return}
            
            let trimmedString = word.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            let charCount = trimmedString.characters.count
            
            if (charCount > 0) {
                
                let range2 = word.rangeOfCharacter(from: .alphanumerics)
                let range3 = word.rangeOfCharacter(from: .punctuationCharacters)
                let range4 = word.rangeOfCharacter(from: .newlines)

                if (range2 == nil && range3 == nil && range4 == nil) {
                
                    if (charCount == 1) {

                        let scalars = word.unicodeScalars
                        
                        let scalarValue = scalars[scalars.startIndex].value
                        
                        if (scalarValue >= 9728 && scalarValue <= 9983) {
                            
                            emojis.append(word)
                        }
                    }
                    else {
                        emojis.append(word)
                    }

                }
            }
        }
        
        return emojis
    }
}
