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
            }
        }
    }
    
    mutating func checkCardsAndCountScore(firstCardIndex cardIndex: Int, secondCardIndex mathcedCardIndex: Int) {

        // если одна из карт имеет признак совпавшей, то и другая тоже
        if cards[cardIndex].isMatched{
            // если обе карты уже были открыты ранее
            if cards[cardIndex].wasFacedUpDate != nil && cards[mathcedCardIndex].wasFacedUpDate != nil{
                
                // возьмем максимальную дату из двух совпадающих карт, считая что отсчет надо вести, когда игрок обнаружил последнюю из совпадающих карт, после этого он, при наличии хорошей памяти, знает, где обе карты и должны открыть их быстро, будем анализировать это время
                let maxDateOfTwoMatchedCards = max(cards[cardIndex].wasFacedUpDate!, cards[mathcedCardIndex].wasFacedUpDate!)
                
                let duration = Date().timeIntervalSince(maxDateOfTwoMatchedCards)
                
                // установим стандартное количество балов за угадывание пары
                var points = 2
                
                switch duration{
                // если открыли совпадение за 3 секунды, то увеличим вдвое количество стандартных очков
                case 0...3:
                    points *= 2
                // если открыли совпадние от 4 до 6 секунд, то дадим на 1 бал больше, чем стандарт
                case 4...6:
                    points += 1
                default:
                    break
                }
                
                countScores += points
                
            }
            // если обе карты открыты наугад и произошло совпадение - дадим 8 очков
            else{
                if cards[cardIndex].wasFacedUpDate == nil && cards[mathcedCardIndex].wasFacedUpDate == nil{
                    countScores += 8
                }
                // если одна из совпавших карт ранее не была открыта - дадим 6 очков
                else{
                        countScores += 6
                }
                
            }
            
        }else{
            if cards[cardIndex].wasFacedUpDate == nil {
                cards[cardIndex].wasFacedUpDate = Date()
            }else{
                countScores -= 1
            }
            
            if cards[mathcedCardIndex].wasFacedUpDate == nil{
                cards[mathcedCardIndex].wasFacedUpDate = Date()
            }else{
                countScores -= 1
            }
            
        }
    }
    
    
    mutating func startNewGame(){
        countFlips = 0
        countScores = 0
        for i in 0..<cards.count{
            cards[i].isFaceUp = false
            cards[i].isMatched = false
            cards[i].wasFacedUpDate = nil
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

