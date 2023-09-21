//
//  GameStatsViewController.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-06.
//

import UIKit

class GameStatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        // Do any additional setup after loading the view.
    }
    private func addBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "Bg_01")
        // Add the UIImageView as a subview to the view controller's view
        self.view.insertSubview(backgroundImage, at: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
