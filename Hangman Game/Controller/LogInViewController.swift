//
//  LogInViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-09-21.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var playerNameInput: UITextField!
    @IBOutlet weak var playerEmailInput: UITextField!

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        playerNameInput.resignFirstResponder ()
        playerEmailInput.resignFirstResponder ()
    }
    

    @IBAction func signInBtnTapped(_ sender: UIButton) {
        let playerName = playerNameInput.text ?? "New Player"
        let name = playerName.isEmpty ? "New Player" : playerName
        let playerEmail = playerEmailInput.text ?? "newPlayer@newPlayer.com"
        let email = playerEmail.isEmpty ? "newPlayer@newPlayer.com" : playerEmail
        createPlayer(name, _email: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        playerNameInput.text = ""
        playerEmailInput.text = ""
   
        // Do any additional setup after loading the view.
    }
    
    private func addBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "Bg_01")
        // Add the UIImageView as a subview to the view controller's view
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func createPlayer(_ name: String, _email: String) {
        let player = Player(name: name, email: _email)
        GameStats.shared.save(player: player)
        let identifier = "goToWelcomePage"
        goToNextVC( identifier: identifier, sender: player)
    }
    
    private func goToNextVC( identifier: String, sender: Any){
        self.performSegue(withIdentifier: identifier, sender: self)

    }


}
