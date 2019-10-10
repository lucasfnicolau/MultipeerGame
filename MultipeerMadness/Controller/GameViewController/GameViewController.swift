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
    @IBOutlet weak var isAvailableSwitch: UISwitch!
    @IBOutlet weak var playButton: UIButton!
    
    let serviceManager = ServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MultipeerManager.start(withDelegate: self)
        
        serviceManager.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = GameScene(fileNamed: "GameScene")
            scene.session = serviceManager.session
            serviceManager.sceneDelegate = scene
            
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
    
    func hostSession(action: UIAlertAction) {
        MultipeerManager.startSession()
        scene.addPlayer(index: 0)
    }

    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: Service.multiplayerGame.rawValue, session: MultipeerManager.mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @IBAction func changeAvailability() {
        playButton.isEnabled = !playButton.isEnabled
        
        switch isAvailableSwitch.isOn {
        case true:
            serviceManager.goLive()
        default:
            serviceManager.goOffline()
        }
    }
    
    @IBAction func startGame() {
        let playersNumber = serviceManager.session.connectedPeers.count
        
        if (ServiceManager.peerID.pid == 0) {
            serviceManager.send(value: "players:\(playersNumber)")
            serviceManager.sceneDelegate?.addNodes(quantity: playersNumber)
        }
        serviceManager.send(value: "play:")
    }
}

extension GameViewController: ServiceDelegate {

    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

}
