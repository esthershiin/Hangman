//
//  HangmanViewController
//  Hangman
//
//  Created by iOS Decal on Feb 11 2020.
//  Copyright © 2020 iosdecal. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    // MARK: - Instances: Models
    var hangman = Hangman()
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var correctGuessesLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    
    // MARK: - Class Props/Vars
    var hintUsedAlready = false
    
    // MARK: - IBActions
    @IBAction func guessButtonPressed(_ sender: Any) {
        playTurn()
        endGame()
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        reset()
    }
    
    @IBAction func hintButtonPressed(_ sender: Any) {
        if (hintUsedAlready == true) {
            let usedAlert = UIAlertController(title: "No more hints!", message: "This isn't Stanford–you can't get everything handed to you! Tap anywhere to dismiss this alert.", preferredStyle: .alert)
            self.present(usedAlert, animated: true, completion:{
                usedAlert.view.superview?.isUserInteractionEnabled = true
                usedAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        } else {
            var hint = hangman.secretWord.randomElement()
            while hangman.correctGuesses.contains(hint!) {
                hint = hangman.secretWord.randomElement()
            }
            guessTextField.text = String(hint!)
            hintUsedAlready = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        incorrectGuessesLabel.text = "INCORRECT GUESSES:"
        imageView.image = UIImage(named: "hangman0.png")
        var correctGuesses = "_"
        for _ in 1..<hangman.secretWord.count {
            correctGuesses += " _"
        }
        correctGuessesLabel.text = correctGuesses
    }
    
    // MARK: - Class Methods
    
    /* Resets this game by creating a new model and appropriately updating all labels/images. */
    private func reset() -> Void {
        hangman = Hangman()
        incorrectGuessesLabel.text = "INCORRECT GUESSES:"
        imageView.image = UIImage(named: "hangman0.png")
        hintUsedAlready = false
        var correctGuesses = "_"
        for _ in 1..<hangman.secretWord.count {
            correctGuesses += " _"
        }
        correctGuessesLabel.text = correctGuesses
    }
    
    /* A wrapper function to handle the reset button sent by the game over alerts. */
    private func resetHandler(action: UIAlertAction) -> Void {
        reset()
    }
    
    /* Play turn takes in the user's guess and first checks if it is valid. If it is NOT valid, it sends a dismissable alert letting the user know their guess is not valid. If it is valid, we make a guess according to our model. The model is updated. If the guess is correct, we update our correctGuessesLabel. If it is incorrect, we update the incorrectGuessesLabel and our hangman image. */
    private func playTurn() -> Void {
        if let letter = guessTextField.text {
            if hangman.checkValidGuess(letter) {
                if hangman.makeGuess(letter) {
                    //correct guess
                    correctGuessesLabel.text = updatedCorrectString()
                } else {
                    //incorrect guess
                    if let prev = incorrectGuessesLabel.text {
                        incorrectGuessesLabel.text = prev + " " + letter
                    }
                    //change imageview to next stage tree
                    imageView.image = UIImage(named: "hangman\(hangman.wrongGuessCount).png")
                }
            } else {
                let invalidAlert = UIAlertController(title: "Invalid guess!", message: "Guesses must be one alphabet character or one space that you have not already guessed. Tap anywhere to dismiss this alert.", preferredStyle: .alert)
                self.present(invalidAlert, animated: true, completion:{
                    invalidAlert.view.superview?.isUserInteractionEnabled = true
                    invalidAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
                })
            }
        }
    }
    
    /* Dismisses an alert by tapping outside of the alert. */
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    /* This function checks whether or not the game should end, for any reason, and if it should, sends an appropriate alert. The alerts can only be dismissed by starting a new game, such that the user may not continue making guesses on a completed game. */
    private func endGame() -> Void {
        if hangman.checkWon() {
            let winAlert = UIAlertController(title: "You won!", message: "Go Bears! The word was \" \(hangman.secretWord)\"", preferredStyle: .alert)
            winAlert.addAction(UIAlertAction(title: "Start new game", style: .default, handler: resetHandler))
            self.present(winAlert, animated: true, completion: nil)
        } else if hangman.checkLost() {
            let loseAlert = UIAlertController(title: "You lost :(", message: "The word was \" \(hangman.secretWord)\". Stanturd wins this round.", preferredStyle: .alert)
            loseAlert.addAction(UIAlertAction(title: "Start new game", style: .default, handler: resetHandler))
            self.present(loseAlert, animated: true, completion: nil)
        }
    }
    
    /* updatedCorrectString returns a new version of our corrected guesses, based of this controller's Hangman model. This string should be of the format "B _ A _" where the underscores represented letters not yet guessed, and the filled in letters are correct letters the user has guessed. */
    func updatedCorrectString() -> String {
        var result = ""
        for letter in hangman.secretWord {
            if (hangman.correctGuesses.contains(letter.lowercased())) {
                result += String(letter)
            } else {
                result += "_"
            }
            result += " "
        }
        return String(result.dropLast())
    }
}
