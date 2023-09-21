//
//  MovieModeViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-06.
//

import UIKit

class MovieModeViewController: UIViewController {
    
    @IBOutlet var KeyboardButtons: [UIButton]!
    ///label tag components:
    @IBOutlet weak var titleLabelContainer: UIStackView!
    @IBOutlet weak var titleCaracterComponent: UIStackView!
    @IBOutlet weak var correctTriesLabel: UILabel!
    @IBOutlet weak var missedTriesLabel: UILabel!
    
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!  //TODO: Label to test if we got the film title, delete after finished testing the game.
    @IBOutlet weak var newMovieGameButton: UIButton!
    
    let message: String = ""
    var movie: Movie!
    var movieTitle: String = ""
    var currentGameMissedTries: Int = 0
    var currentGameTries = 0
    var correctLettersGuessed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startApp()
    }
    
    private func setupUI() {
        addBackground()
        movieTitleLabel.isHidden = true /// Hide the test label during the game.
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
    
    private func formatKeyboardButton (button: UIButton) {
        button.isEnabled = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 8/256, green: 60/256, blue: 129/256, alpha: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
    }
    
    private func startApp () {
        self.toggleActivityIndicator(shown: true)
        getNewMovie()
    }
    
    private func resetScores() {
        currentGameMissedTries  = 0
        currentGameTries = 0
        correctLettersGuessed = 0
        updateMissedLabel(missedTries: currentGameMissedTries)
        updateCorrectLabel(correctTries: correctLettersGuessed)
        titleLabelContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func PlayNewMovieGame(_ sender: Any) {
        getNewMovie()
        configureKeyboardButtons()
        }
    
    
    func getNewMovie() {
        let imageName = "Hang00"
        let image = UIImage(named: imageName)
        hangmanImage.image = image
        
        self.toggleActivityIndicator(shown: true)
        MovieManager.shared.getMovie() { (success, data) in
            self.toggleActivityIndicator(shown: false)
            guard let data = data, success == true else {
                self.presentAlert()
                return
            }
            self.movie = data
            if self.movie.type != "movie" {
                self.startApp()
            }
            else if self.movie.title.count > 16 {
                self.startApp()
            }
            else {
                DispatchQueue.main.async {
                self.movieTitle = self.movie.title
                self.movieTitleLabel.text = self.movieTitle.uppercased()
                    self.resetScores()
                    self.createMovieTitleLabel(title: self.movieTitle)
                }
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        newMovieGameButton.isHidden = shown
        activityIndicator.isHidden = !shown
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
            if (self.movie?.released) != nil {
                presentAlertGameTip (message: "This movie was released on \(self.movie.released).")
            }
        case 3:
            imageName =  "Hang03.png"
        case 4:
            imageName =  "Hang04.png"
            presentAlertGameTip(message: "This movie is a \(self.movie.genre) and has this IMDB ratings: \(self.movie.rating[0].value).")
        case 5:
            imageName = "Hang05.png"
            presentAlertGameTip (message: "This movie's director(s) is/are \(self.movie.directors) and has these actors: \(self.movie.actors).")
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
        let movieTitle = self.movie.title.uppercased()
        return movieTitle.contains(letter)
    }
    
    var numberOfLetters: Int!
    private func countCorrectLetters(letter: String) -> Int {
        let originalString = self.movie.title.uppercased()
        if let firstCharacter = letter.first {
            let selectedLetter = firstCharacter
            numberOfLetters = originalString.filter { $0 == selectedLetter }.count
        }
        print("number of letters: \(String(describing: numberOfLetters))")
        return numberOfLetters
    }
    
    private func showLetters(letter: String){
        if let titleLabelContainer = titleLabelContainer {
            for i in 0..<titleLabelContainer.arrangedSubviews.count {
                let stackCharContainer = titleLabelContainer.arrangedSubviews[i]
                if let charLabel = stackCharContainer.subviews.first as? UILabel, charLabel.text?.uppercased() == letter {
                    charLabel.textColor = UIColor.white //(red: 200/256, green: 111/256, blue: 180/256, alpha: 1)
                }
                print("charLabelText: \(String(describing: (stackCharContainer.subviews.first as? UILabel)?.text))")
                print("letter: \(letter)")
            }
        }
    }
    
    private func updateCorrectLabel(correctTries: Int) {
        let numberValidCharacters = getValidNumberOfCharacters()
        correctTriesLabel.text = "\(correctTries)/\(numberValidCharacters)"
        if correctTries == numberValidCharacters {
            presentAlertGameStatus(message: "Congratulations!")
            finishGame()
        }
    }
    
    private func getValidNumberOfCharacters() -> Int {
        let originalString = self.movie.title
        let stringWithoutSpaces = originalString.replacingOccurrences(of: " ", with: "")
        let numberOfCharactersWithoutSpaces = stringWithoutSpaces.count
        return numberOfCharactersWithoutSpaces
    }
    

   
    private func createMovieTitleLabel(title: String) {
        titleLabelContainer.axis = .horizontal // Set the axis to horizontal for a horizontal stack view
        titleLabelContainer.alignment = .center // Set the alignment to center for the stack view
        titleLabelContainer.spacing = 10 // Set the spacing between labels
        let titleString = title
        titleString.forEach { char in
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
            guideLabel.textColor = UIColor.white // UIColor(red: 230/256, green: 231/256, blue: 180/256, alpha: 1)
            charLabel.textColor = UIColor.clear
            stackCharContainer.addArrangedSubview(charLabel)
            stackCharContainer.addArrangedSubview(guideLabel)
            
            titleLabelContainer.addArrangedSubview(stackCharContainer) // Add stackCharContainer to the titleLabelContainer
        }
    }
    
}
        

