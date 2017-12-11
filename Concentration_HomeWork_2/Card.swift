//
//  Card.swift
//  Concentration_HomeWork_2
//
//  Created by sealucky on 28.11.2017.
//  Copyright © 2017 sealucky. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int {
    return identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
       return lhs.identifier == rhs.identifier
    }
    
    var isMatched = false
    var isFaceUp = false
    var wasFacedUpDate: Date?
    
    private var identifier: Int
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
