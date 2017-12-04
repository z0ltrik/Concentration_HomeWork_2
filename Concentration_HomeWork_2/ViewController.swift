//
//  ViewController.swift
//  Concentration_HomeWork_2
//
//  Created by sealucky on 28.11.2017.
//  Copyright © 2017 sealucky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCoutLabel()
        }
    }
    
    
    var numberOfpairsOfCards: Int {
        get{
            return (cardButtons.count + 1) / 2
        }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfpairsOfCards)
    
    private(set) var countFlips = 0 {
        didSet{
            updateFlipCoutLabel()
        }
    }
    private func updateFlipCoutLabel(){
        let attributesForLabel: [NSAttributedStringKey: Any] = [
            .strokeColor: UIColor.orange,
            .strokeWidth: 3.0
        ]
        flipCountLabel.attributedText = NSAttributedString(string: "Flip: \(countFlips)", attributes: attributesForLabel)
    }
    
    //private var emojiChoices = ["👹","👻","🎃","🧜‍♂️","👽","🧙‍♂️","😈","🧞‍♂️","🧟‍♂️","🤖"]
    private var emojiChoices = "👹👻🎃🧜‍♂️👽🧙‍♂️😈🧞‍♂️🧟‍♂️🤖"
    
    private var emoji = [Card:String]()
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateCardButtonsView()
        }
        countFlips += 1
    }
    
    func updateCardButtonsView(){
        for index in cardButtons.indices {
            if game.cards[index].isFaceUp {
                cardButtons[index].setTitle(getEmoji(for: game.cards[index]), for: UIControlState.normal)
                cardButtons[index].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            else{
                cardButtons[index].setTitle(" ", for: UIControlState.normal)
                cardButtons[index].backgroundColor = !game.cards[index].isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    func getEmoji(for card: Card) -> String{
        let foundEmoji = emoji[card]
        if foundEmoji == nil && emojiChoices.count > 0 {
            let randomEmojiIndex = emojiChoices.count.randomInt
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: randomEmojiIndex)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
// end of the class
}

