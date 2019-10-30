//
//  GameOverViewController.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 23/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameOverViewController: UIViewController {

    var winner = -1
    var serviceManager: ServiceManager?
    @IBOutlet weak var winnerImageView: UIImageView!
    @IBOutlet weak var winnerImageViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
//        if deviceIdiom == .pad {
//            winnerImageViewTopConstraint.constant = 140
//            winnerImageViewTopConstraint.constant = 48
//        }
        
        winnerImageView.image = UIImage(named: "lobby\(winner)")
    }
    
    @IBAction func exit() {
        serviceManager = nil
        performSegue(withIdentifier: "menu", sender: self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
