//
//  GameViewController.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 08/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameViewController: UIViewController {

    var scene: GameScene!
    var serviceManager: ServiceManager!
    var name = ""
    var playersNumber = 0
    var winner = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextureManager.shared.preloadAssets() {
            print("Texturas caregadas...")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            self.scene = GameScene(fileNamed: "GameScene")
            self.scene.session = self.serviceManager.session
            self.serviceManager.sceneDelegate = self.scene
            self.scene.playersNumber = playersNumber
            
            // Set the scale mode to scale to fit the window
            self.scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(self.scene)
            
            view.ignoresSiblingOrder = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(gotoGameOverVC(_:)), name: NSNotification.Name(rawValue: "gameOver"), object: nil)
            
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
    }
    
    @objc func gotoGameOverVC(_ notif: Notification) {
        guard let userInfo = notif.userInfo else { return }
        guard let winner = userInfo["winner"] as? Int else { return }
        self.winner = winner
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameOverVC = segue.destination as? GameOverViewController {
            gameOverVC.modalPresentationStyle = .fullScreen
            gameOverVC.winner = winner
            gameOverVC.serviceManager = serviceManager
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
}
