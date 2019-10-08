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

class CustomMCPeerID: MCPeerID {
    var pid: Int = -1
    
    override init(displayName myDisplayName: String) {
        super.init(displayName: myDisplayName)
    }
    
    init(pid: Int, withDisplayName displayName: String) {
        super.init(displayName: displayName)
        self.pid = pid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    static var peerID: CustomMCPeerID!
    static var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var messageToSend: String!
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectionMenu))
        
        GameViewController.peerID = CustomMCPeerID(displayName: UIDevice.current.name)
        GameViewController.mcSession = MCSession(peer: GameViewController.peerID, securityIdentity: nil, encryptionPreference: .required)
        GameViewController.mcSession.delegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = GameScene(fileNamed: "GameScene")
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
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func showConnectionMenu() {
        let ac = UIAlertController(title: "Connection Menu", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func hostSession(action: UIAlertAction) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ioscreator-chat", discoveryInfo: nil, session: GameViewController.mcSession)
        mcAdvertiserAssistant.start()
        GameViewController.peerID.pid = 0
        scene.addPlayer(index: 0)
    }

    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: "ioscreator-chat", session: GameViewController.mcSession)
      mcBrowser.delegate = self
      present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      switch state {
      case .connected:
        
        let playersNumber = GameViewController.mcSession.connectedPeers.count
        if GameViewController.peerID.pid != 0 {
            GameViewController.peerID.pid = playersNumber
        }
        
        if (GameViewController.peerID.pid == 0) {
            send("players:\(playersNumber)")
            scene.addPlayer(index: playersNumber)
        }
        
        print("Connected: \(GameViewController.peerID.displayName)")
      case .connecting:
        print("Connecting: \(GameViewController.peerID.displayName)")
      case .notConnected:
        print("Not Connected: \(GameViewController.peerID.displayName)")
      @unknown default:
        print("fatal error")
      }
    }
    
    func send(_ value: String) {
        
        let data = value.data(using: .utf8)
        do {
            try GameViewController.mcSession.send(data!, toPeers: GameViewController.mcSession.connectedPeers, with: .unreliable)
        }
        catch {
            print("Error sending message")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      DispatchQueue.main.async { [unowned self] in
    
        guard let value = String(data: data, encoding: .utf8) else { return }
        let keyValue = value.split(separator: ":")
        
        if keyValue[0] == Substring("players") {
            let playersNumber = Int(keyValue[1]) ?? 1
            for index in self.scene.circles.count ... playersNumber {
                self.scene.addPlayer(index: index)
            }
        } else {

        }
        
      }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
