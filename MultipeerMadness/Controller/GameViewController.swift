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
    
    let serviceManager = ServiceManager()
    
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let map = SKTextureAtlas(named: "Map")
        SKTextureAtlas.preloadTextureAtlases([map]) {
            print("tudo carregado")
        }
        
        serviceManager.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = GameScene(fileNamed: "GameScene")
            scene.session = serviceManager.session
            serviceManager.sceneDelegate = scene
            
            if name == "host" {
                serviceManager.createSession()
                ServiceManager.peerID.pid = 0
            } else {
                serviceManager.enterSession()
            }
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
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
    
    @IBAction func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
            
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            let currentScale = scene.map.xScale
//            var newScale = gestureRecognizer.scale
//            if currentScale * gestureRecognizer.scale < 0.1 {
//                newScale = 0.1 / currentScale
//            } else if currentScale * gestureRecognizer.scale > 1 {
//                newScale = 1 / currentScale
//            }
//
//            scene.map.set;Scale(newScale)
//            print("current scale: \(currentScale), new scale: \(newScale)")
//
////            gestureRecognizer.scale = 1
//        }
        
    }
}

extension GameViewController: ServiceManagerDelegate {

    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
            
        }
    }

}
