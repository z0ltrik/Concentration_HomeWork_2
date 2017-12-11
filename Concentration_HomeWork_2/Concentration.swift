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
    
    // определим исходное значение 1970 годом
    private var timOfOpenOneAndOnlyFaceUpCard = Date(timeIntervalSince1970: 0)
    
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
        if !cards[index].isMatched{
            countFlips += 1
            if let matchedIndex = indexOfOneAndOnlyFaceUpCard, index != matchedIndex {
                if cards[index] == cards[matchedIndex] {
                    cards[index].isMatched = true
                    cards[matchedIndex].isMatched = true
                }
                
                checkCardsAndCountScore(firstCardIndex: index, secondCardIndex: matchedIndex)
                
                cards[index].isFaceUp = true
                
            }else{
                indexOfOneAndOnlyFaceUpCard = index
                timOfOpenOneAndOnlyFaceUpCard = Date()
            }
        }
    }
    
    mutating func checkCardsAndCountScore(firstCardIndex cardIndex: Int, secondCardIndex mathcedCardIndex: Int) {
        
        // если одна из карт имеет признак совпавшей, то и другая тоже
        if cards[cardIndex].isMatched{
            // если обе карты открылись впервые, то даем супер-приз за удачу - 10 очков
            if !cards[cardIndex].wasFacedUp && !cards[mathcedCardIndex].wasFacedUp{
                countScores += 10
            }else{
                // определим разницу между текущим временем и временем открытия первой карты
                let duration = Date().timeIntervalSince(timOfOpenOneAndOnlyFaceUpCard)
                // установим стандартное количество балов за угадывание пары
                var points = 2
                
                switch duration{
                // если открыли совпадение за 3 секунды, то увеличим вдвое количество стандартных очков
                case 0...3:
                    points *= 2
                // если открыли совпадние от 4 до 6 секунд, то дадим на 1 бал больше, чем стандарт
                case 4...7:
                    points += 1
                default:
                    break
                }
                countScores += points
            }
            
        }else{
            if !cards[cardIndex].wasFacedUp {
                cards[cardIndex].wasFacedUp = true
            }else{
                countScores -= 1
            }
            
            if !cards[mathcedCardIndex].wasFacedUp{
                cards[mathcedCardIndex].wasFacedUp = true
            }else{
                countScores -= 1
            }
            
        }
    }
    
    
    mutating func startNewGame(){
        countFlips = 0
        countScores = 0
        for i in 0..<cards.count{
            cards[i].isFaceUp   = false
            cards[i].isMatched  = false
            cards[i].wasFacedUp = false
        }
        cards.shuffle()
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

