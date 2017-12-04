//
//  Concentration.swift
//  Concentration_HomeWork_2
//
//  Created by sealucky on 28.11.2017.
//  Copyright © 2017 sealucky. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get{
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnlyElementInCollection
        }
        set (newIndex) {
            for index in cards.indices {
                cards[index].isFaceUp = newIndex == index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards>0, "Concentraition.chooseCards: \(numberOfPairsOfCards): you must have at list one pair of cards")
        for _ in 1...numberOfPairsOfCards{
            let newCard = Card()
            cards += [newCard, newCard]
        }
        cards.shuffle()
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentraition.chooseCards: \(index): index is not in the cards")
        if !cards[index].isMatched{
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, index != matchedIndex {
                    if cards[index] == cards[matchedIndex] {
                        cards[index].isMatched = true
                        cards[matchedIndex].isMatched = true
                    }
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

extension Collection {
    var oneAndOnlyElementInCollection: Element? {
        return count == 1 ? first : nil
    }
}

extension Int {
    var randomInt: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

extension Array{
    mutating func shuffle(){
        var last = count-1
        while last > 0 {
            let randomIndex = last.randomInt
            swapAt(last, randomIndex)
            last -= 1
        }
    }
}
