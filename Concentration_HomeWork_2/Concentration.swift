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
    private(set) var countFlips = 0
    
    private(set) var countScores = 0
    
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
        countFlips += 1
        if !cards[index].isMatched{
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, index != matchedIndex {
                if cards[index] == cards[matchedIndex] {
                    cards[index].isMatched = true
                    cards[matchedIndex].isMatched = true
                }
                checkCardAndCountScore(with: index)
                checkCardAndCountScore(with: matchedIndex)
                
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    mutating func checkCardAndCountScore(with indexOfCard: Int) {
        if cards[indexOfCard].isMatched{
            countScores += 1
        }else{
            if cards[indexOfCard].wasFacedUp != true {
                for index in cards.indices {
                    if cards[index] == cards[indexOfCard]{
                        cards[index].wasFacedUp = true
                    }
                }
            }else{
                countScores -= 1
            }
        }
    }
    
    mutating func shuffleCards(){
        for i in 0..<cards.count{
            cards[i].isFaceUp = false
            cards[i].isMatched = false
            cards[i].wasFacedUp = false
        }
        cards.shuffle()
    }
    
    mutating func startNewGame(){
        countFlips = 0
        countScores = 0
        shuffleCards()
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
        if count < 2 {return}
        var last = count-1
        while last > 0 {
            let randomIndex = last.randomInt
            swapAt(last, randomIndex)
            last -= 1
        }
    }
}

