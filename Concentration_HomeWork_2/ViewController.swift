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
            updateLabel(flipCountLabel, withText: "Flip: 0", textColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
        }
    }
    
    @IBOutlet weak var scoresLabel: UILabel!{
        didSet{
            updateLabel(scoresLabel, withText: "Scores: 0", textColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        }
    }
    
    var numberOfpairsOfCards: Int {
        get{
            return (cardButtons.count + 1) / 2
        }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfpairsOfCards)
    
    private func updateLabel(_ label: UILabel, withText text: String, textColor:UIColor){
        let attributesForLabel: [NSAttributedStringKey: Any] = [
            .strokeColor: textColor,
            .strokeWidth: -3.0
        ]
        label.attributedText = NSAttributedString(string: text, attributes: attributesForLabel)
    }
    
    private let gameThemes: Dictionary<String,String> =
        [ "Halloween":   "👹👻🎃🧜‍♂️👽🧙‍♂️😈🧞‍♂️🧟‍♂️🤖🧛‍♂️🧚‍♀️",
          "Transport":   "🛴🚲🚄🛵🏍🚜✈️🚀🛳🚁🏎🚌",
          "Animals":     "🐶🐱🐹🦊🐻🐼🐨🐯🐸🐮🦁🐵",
          "Fruits":      "🍎🍐🍊🍋🍌🍉🍇🍓🥥🥝🍍🍒",
          "Food":        "🥪🍳🍪🥞🌮🌯🍕🥗🍣🍥🍦🍭",
          "Activities":   "⚽️⛹️‍♂️🏄‍♂️🏊‍♂️🏓🚴‍♂️🏇🏌️‍♂️🏒🤼‍♂️🏂🤺"
    ]
    
    lazy private var emojiChoices = pickTheme()
    
    private var emoji = [Card:String]()
    
    func getEmoji(for card: Card) -> String{
        let foundEmoji = emoji[card]
        if foundEmoji == nil && emojiChoices.count > 0 {
            let randomEmojiIndex = emojiChoices.count.randomInt
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: randomEmojiIndex)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    func updateCardButtonsAndLabelsView(){
        
        updateLabel(flipCountLabel, withText: "Flips: \(game.countFlips)", textColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
        updateLabel(scoresLabel, withText: "Scores: \(game.countScores)", textColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        
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
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            game.chooseCard(at: cardIndex)
            updateCardButtonsAndLabelsView()
        }
        //   countFlips += 1
    }
    
    func pickTheme() -> String{
        let gameThemeKeys = Array(gameThemes.keys)
        let randomGameThemeKey = gameThemeKeys[gameThemeKeys.count.randomInt]
        if let randomThemeEmoji = gameThemes[randomGameThemeKey] {
            return randomThemeEmoji
        } else{
            return ""
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        emojiChoices = pickTheme()
        game.startNewGame()
        emoji = [Card:String]()
        updateCardButtonsAndLabelsView()
    }
    
    
    // end of the class
}

