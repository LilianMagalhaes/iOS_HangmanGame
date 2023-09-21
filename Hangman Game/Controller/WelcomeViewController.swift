//
//  WelcomeViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-06.
//

import UIKit

class WelcomeViewController: UIViewController {
    var player: Player?
    var name: String = ""
    
    @IBOutlet weak var moviesModeBtn: UIButton!
    @IBOutlet weak var dictionaryModeBtn: UIButton!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var changeUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = player?.name ?? "NewPlayer"
        displayWelcomeLabel(name:name)
        print(name)
        addBackground()
        changeUserBtn.isHidden = false
        themeLabel.isHidden = false
        moviesModeBtn.isEnabled = true
        dictionaryModeBtn.isEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeUserBtnTapped(_ sender: UIButton) {
        //TODO: Return to login page (LogOut)
    }
    
    @IBAction func moviesModeBtnIsTapped(_ sender: UIButton) {
        let identifier = "goToMoviesMode"
        goToNextVC( identifier: identifier, sender: self)
    }
    
    @IBAction func dictionaryModeBtnIsTapped(_ sender: UIButton) {
        let identifier = "goToDictionaryMode"
        goToNextVC( identifier: identifier, sender: self)
    }
    
    private func addBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Bg_01")
        // Add the UIImageView as a subview to the view controller's view
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func displayWelcomeLabel(name:String) {
        welcomeLabel.text = "Welcome \(name)!"
    }
    
    private func goToNextVC( identifier: String, sender: Any){
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
