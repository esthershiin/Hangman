//
//  Hangman.swift
//  Hangman
//
//  Created by Jackson Chui on 2/20/20.
//  Copyright © 2020 Tim's Apples. All rights reserved.
//

import Foundation

class Hangman {
    
    init() {
        secretWord = wwdcArray.randomElement()!
    }
    
    /* Letters guessed contains LOWERCASE letters only */
    var lettersGuessed: [String] = []
    var secretWord: String = ""
    var wrongGuessCount: Int = 0
    var correctGuesses: String = ""
    let maxAttempts: Int = 7
    
    let wwdcArray:[String] = [
        "Go Bears",
        "Stan Carol Christ",
        "Take back the axe",
        "Voldemort went to Stanford",
        "Queen Marc Fisher",
        "Lecture on zoom baby",
        "Blue and gold every day",
        "I would die for Oski",
        "UC Berkeley Memes for Edgy Teens",
        "Overhead on UC Berkeley",
        "Confessions from UC Berkeley",
        "Party at Zellerbach",
        "Soda or Cory",
        "Housing crisis say whaaaat",
        "Hike to the big C",
        "Very tall tower",
        "Fresh beatz from the Campanille",
        "Please make a private Piazza post",
        "Kiwibot autonomy",
        "Give the squirrels treats",
        "We DESERVE UCha after that midterm",
        "Twelve units of Decals",
        "Cardinals are unsexy",
        "Fiat Lux",
        "Slivers vs Cheeseboard vs Artichoke",
        "All nighter at Moffitt time",
        "Bearwalk time",
        "Does anyone have a bid",
        "Read it in the Daily Cal",
        "Yummy Crossorads",
        "Cal Day AND Four Twenty",
        "Durant Ave Taco Bell Saved Me",
        "Number One Public University",
        "Naked Run",
        "Take a class with Filippenko",
        "UCLA Stole our fight song",
        "Would you like a flyer",
        "Berzerkeley",
        "Do the Cal two step",
        "Quizlet saved me"
    ]
    
    /* makeGuess takes in a character, which has been guessed by the user. If the character is in this Hangman game's secret word, then it returns true. Otherwise, it returns false. It adds the new guess to the letters guessed array and increments the amount of wrong guesses*/
    func makeGuess(_ guess : String) -> Bool {
        lettersGuessed.append(guess.lowercased())
        if !secretWord.localizedCaseInsensitiveContains(guess) {
            wrongGuessCount += 1
        } else {
            correctGuesses += guess.lowercased()
        }
        return secretWord.localizedCaseInsensitiveContains(guess)
    }
    
    /* checkValidGuess takes in a character and checks if it's a valid guess. The requirements for validity are that:
        1) The guess is 1 character long
        2) The guess is a letter (upper or lowercase)
        3) The guess has not already been guessed. */
    func checkValidGuess(_ guess : String) -> Bool {
        var result = true
        if guess.count != 1 {
            result = false
        } else if guess.range(of: "[a-zA-Z]\\s", options: .regularExpression) != nil {
            result = false
        } else if lettersGuessed.contains(guess.lowercased()) {
            result = false
        }
        return result
    }
    
    /* Check if the user has lost the game */
    func checkLost() -> Bool {
        return wrongGuessCount == maxAttempts
    }
    
    /* Check if the user has won the game */
    func checkWon() -> Bool {
        var result = true
        for char in secretWord {
            if !correctGuesses.contains(char.lowercased()) {
                result = false
            }
        }
        return result
    }
    
}

