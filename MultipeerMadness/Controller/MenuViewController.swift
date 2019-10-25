//
//  MenuViewController.swift
//  MultipeerMadness
//
//  Created by Matheus Silva on 10/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LobbyViewController {
            vc.modalPresentationStyle = .fullScreen
            if segue.identifier == "create" {
                vc.name = "host"
            } else {
                vc.name = "client"
            }
        }
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
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) { }
}
