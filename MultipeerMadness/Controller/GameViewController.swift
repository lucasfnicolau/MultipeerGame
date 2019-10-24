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
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    var serviceManager: ServiceManager!
    var name = ""

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
            
            // Set the scale mode to scale to fit the window
            self.scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(self.scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
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
