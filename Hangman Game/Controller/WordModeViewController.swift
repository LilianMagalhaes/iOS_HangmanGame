//
//  WordModeViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-18.
//

import UIKit

class WordModeViewController: UIViewController {
    
    private var wordString: String = ""
    private var definition: String = ""
    private var partOfSpeech: String = ""
    private var typeOf: String = ""
    
    @IBOutlet var KeyboardButtons: [UIButton]!
    @IBOutlet weak var wordLabelContainer: UIStackView!
    @IBOutlet weak var correctTriesLabel: UILabel!
    @IBOutlet weak var missedTriesLabel: UILabel!
    
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var wordLabelTest: UILabel!  //TODO: Label to test if we got the film title, delete after finished testing the game.
    @IBOutlet weak var newWordGameButton: UIButton!
    
    let message: String = ""
    var currentGameMissedTries: Int = 0
    var currentGameTries = 0
    var correctLettersGuessed = 0
    
    let data: Data = Data()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startApp()
    }
    
    
    private func setupUI() {
        addBackground()
        wordLabelTest.isHidden = false /// Hide the test label during the game.
        configureKeyboardButtons()
    }
    
    private func configureKeyboardButtons() {
        for button in KeyboardButtons {
            formatKeyboardButton(button: button)
            button.addTarget(self, action: #selector(keyboardButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private func addBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Bg_01")
        /// Add the UIImageView as a subview to the view controller's view
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func formatKeyboardButton(button: UIButton) {
        button.setTitleColor(UIColor.white, for: .application)
        button.isEnabled = true
        button.backgroundColor = UIColor(red: 28/256, green: 78/256, blue: 94/256, alpha: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
    }
    
    private func startApp () {
        self.toggleActivityIndicator(shown: true)
        getNewWord()
    }
    
    private func resetScores() {
        currentGameMissedTries  = 0
        currentGameTries = 0
        correctLettersGuessed = 0
        updateMissedLabel(missedTries: currentGameMissedTries)
        updateCorrectLabel(correctTries: correctLettersGuessed)
        wordLabelContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func PlayNewWordGame(_ sender: Any) {
        getNewWord()
        configureKeyboardButtons()
    }
    
    func getNewWord() {
        let imageName = "Hang00"
        let image = UIImage(named: imageName)
        hangmanImage.image = image
        
        self.toggleActivityIndicator(shown: true)
        WordManager.shared.fetchRandomWord (maxRetries: 100) { result in
            switch result {
            case .success(let wordData):
                self.handleWordData(wordData)
                print("Word: \(wordData.word)")
            case .failure(let error):
                // Handle error
                print("Failed to fetch word: \(error)")
            }
        }
        
    }
    
    
    
    private func handleWordData(_ wordData: Word) {
        wordString = wordData.word
        print("wordData:", wordData, "WordCount: ", wordString.count )
        
        DispatchQueue.main.async {
            self.wordLabelTest.text = self.wordString
            self.definition = wordData.results.first?.definition ?? ""
            self.partOfSpeech = wordData.results.first?.partOfSpeech ?? ""
            self.typeOf = wordData.results.first?.typeOf?.joined(separator: ", ") ?? ""
            self.resetScores()
            self.createWordLabel(word: self.wordString.uppercased())
            self.toggleActivityIndicator(shown: false)
        }
        
    }
    
    
    
    
    private func toggleActivityIndicator(shown: Bool) {
        newWordGameButton.isHidden = shown
        activityIndicator.isHidden = !shown
        for button in KeyboardButtons {
            button.isEnabled = !shown
        }
    }
    
    private func updateGameMissedTries() {
        if currentGameMissedTries < 6 {
            currentGameMissedTries += 1
            print(currentGameMissedTries)
            updateGame(missedTries: currentGameMissedTries)
            updateMissedLabel(missedTries: currentGameMissedTries)
        }
        updateGame(missedTries: currentGameMissedTries)
    }
    
    func updateMissedLabel(missedTries: Int){
        missedTriesLabel.text = "\(missedTries)/6"
    }
    
    private func updateScore() {}
    
    private func updateGame(missedTries: Int) {
        var imageName: String = ""
        print("missed Letters: \(missedTries)")
        switch missedTries {
        case 1:
            imageName = "Hang01.png"
        case 2:
            imageName = "Hang02.png"
            presentAlertGameTip (message: "This word definition is: \(self.definition).")
        case 3:
            imageName =  "Hang03.png"
        case 4:
            imageName =  "Hang04.png"
            presentAlertGameTip(message: "This word is a/an: \(self.partOfSpeech).")
        case 5:
            imageName = "Hang05.png"
            presentAlertGameTip(message: "This word is a type of: \(self.typeOf).")
        case 6:
            imageName =  "Hang06.png"
            presentAlertGameStatus(message: "Game is Over")
            finishGame()
        default:
            print ("error reading missed tries")
        }
        let image = UIImage(named: imageName)
        hangmanImage.image = image
    }
    
    private func finishGame() {
        KeyboardButtons.forEach { button in
            button.isEnabled = false
        }
    }
    
    @IBAction func keyboardButtonTapped(_ sender: UIButton) {
        currentGameTries += 1
        print("Total of Tries: \(currentGameTries)")
        var tappedLetter: String
        if let buttonText = sender.titleLabel?.text?.uppercased() {
            sender.backgroundColor = UIColor.clear
            sender.isEnabled = false
            tappedLetter = buttonText.uppercased()
            let doesLetterExists = containsLetter(letter: tappedLetter)
            if doesLetterExists == true {
                let  numberCorrectLettters = countCorrectLetters(letter: tappedLetter)
                showLetters(letter: tappedLetter)
                correctLettersGuessed += numberCorrectLettters
                print("correct Letters: \(correctLettersGuessed)")
                updateCorrectLabel(correctTries: correctLettersGuessed)
            }
            else {
                updateGameMissedTries()
            }
        }
    }
    
    func containsLetter(letter: String) -> Bool {
        let currentWord = wordString.uppercased()
        return currentWord.contains(letter)
    }
    
    var numberOfLetters: Int!
    private func countCorrectLetters(letter: String) -> Int {
        wordString = wordString.uppercased()
        if let firstCharacter = letter.first {
            let selectedLetter = firstCharacter
            numberOfLetters = wordString.filter { $0 == selectedLetter }.count
        }
        print("number of letters: \(String(describing: numberOfLetters))")
        return numberOfLetters
    }
    
    private func showLetters(letter: String){
        if let wordLabelContainer = wordLabelContainer {
            for i in 0..<wordLabelContainer.arrangedSubviews.count {
                let stackCharContainer = wordLabelContainer.arrangedSubviews[i]
                if let charLabel = stackCharContainer.subviews.first as? UILabel, charLabel.text?.uppercased() == letter {
                    charLabel.textColor = UIColor.white //(red: 200/256, green: 111/256, blue: 180/256, alpha: 1)
                }
                print("charLabelText: \(String(describing: (stackCharContainer.subviews.first as? UILabel)?.text))")
                print("letter: \(letter)")
            }
        }
    }
    
    private func updateCorrectLabel(correctTries: Int) {
        let numberValidCharacters = wordString .count
        correctTriesLabel.text = "\(correctTries)/\(numberValidCharacters)"
        if correctTries == numberValidCharacters {
            presentAlertGameStatus(message: "Congratulations!")
            finishGame()
        }
    }
    
    
    private func createWordLabel(word: String) {
        wordLabelContainer.axis = .horizontal // Set the axis to horizontal for a horizontal stack view
        wordLabelContainer.alignment = .center // Set the alignment to center for the stack view
        wordLabelContainer.spacing = 10 // Set the spacing between labels
        let wordString = word
        wordString.forEach { char in
            let stackCharContainer = UIStackView()
            stackCharContainer.axis = .vertical
            stackCharContainer.alignment = .center // Set the alignment to center for the stack view
            stackCharContainer.spacing = -12
            let guideLabel = UILabel()
            let charLabel = UILabel()
            if char == " " {
                guideLabel.text = "" // Display empty string for empty spaces
                charLabel.text = ""
            } else {
                guideLabel.text = "_" // Display "_" for other characters
                charLabel.text = String(char.uppercased()) // Convert character to string and set as text
            }
            guideLabel.font = UIFont(name: "Chalkduster", size: 20)
            charLabel.font = UIFont(name: "Chalkduster", size: 20)
            guideLabel.textAlignment = .center // Center align the guide label's text
            charLabel.textAlignment = .center // Center align the character label's text
            guideLabel.textColor = UIColor.white//UIColor(red: 230/256, green: 231/256, blue: 180/256, alpha: 1)
            charLabel.textColor = UIColor.clear
            stackCharContainer.addArrangedSubview(charLabel)
            stackCharContainer.addArrangedSubview(guideLabel)
            
            wordLabelContainer.addArrangedSubview(stackCharContainer) // Add stackCharContainer to the titleLabelContainer
        }
    }
}

