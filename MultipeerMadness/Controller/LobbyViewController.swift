//
//  LobbyViewController.swift
//  MultipeerMadness
//
//  Created by Amaury A V A Souza on 22/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class LobbyViewController: UIViewController{
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var numeroJogadoresUILabel: UILabel!
    @IBOutlet weak var sairUIButton: UIButton!
    @IBOutlet weak var beginUIButton: UIButton!
    @IBOutlet weak var readyUIButton: UIButton!
    @IBOutlet var playersImageView: [UIImageView]!
    @IBOutlet var playersLabel: [UILabel]!
    @IBOutlet weak var infoLabel: UILabel!
    var prontos: [Bool] = []
    var name = ""
    var playersName = ["Jack", "Locke", "Kate", "Claire"]
    var playersNumber = 0
    var serviceManager: ServiceManager?
    var lobbyName = "" {
        didSet {
            self.startSession()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for imageView in playersImageView {
            imageView.layer.zPosition = 10
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            stackViewTopConstraint.constant = 140
            stackViewBottomConstraint.constant = 48
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isHost() {
            let sessionID = getRandomServiceType()
            infoLabel.text = "Lobby ID: \(sessionID)"
            lobbyName = sessionID
        } else if lobbyName == "" {
            let lobbyNameVC = LobbyNameViewController()
            lobbyNameVC.modalPresentationStyle = .fullScreen
            lobbyNameVC.modalTransitionStyle = .crossDissolve
            lobbyNameVC.lobbyVC = self
            self.navigationController?.present(lobbyNameVC, animated: true, completion: nil)
        }
    }

    func isHost() -> Bool {
        return name == "host"
    }

    func startSession() {
        serviceManager = ServiceManager(lobbyName: "near")
        serviceManager?.lobbyDelegate = self

        if isHost() {
            serviceManager?.createSession()
            ServiceManager.peerID.pid = 0
            readyUIButton.isHidden = true
        } else {
            serviceManager?.enterSession()
            prontos.append(false)
            beginUIButton.isHidden = true
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
    
    @IBAction func readyAction(_ sender: Any) {
        if readyUIButton.isEnabled {
            readyUIButton.isEnabled = false
            for n in 0..<prontos.count {
                if !prontos[n] {
                    prontos[n] = true
                    break
                }
            }
            
        } else {
            readyUIButton.isEnabled = true
            for n in 0..<prontos.count {
                if prontos[n] {
                    prontos[n] = false
                    break
                }
            }
        }
    }
    
    @IBAction func beginAction(_ sender: Any) {
        guard let serviceManager = serviceManager else { return }
        if !serviceManager.session.connectedPeers.isEmpty {
            send("start:")
            self.performSegue(withIdentifier: "begin", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.serviceManager = serviceManager
            vc.playersNumber = playersNumber
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        serviceManager = nil
        ServiceManager.peerID.pid = -1
        serviceManager?.serviceBrowser.stopBrowsingForPeers()
        serviceManager?.serviceAdvertiser.stopAdvertisingPeer()
        navigationController?.popToRootViewController(animated: false)
    }
}

extension LobbyViewController: LobbyDelegate {
    func updatePlayers(to number: Int) {
        DispatchQueue.main.async {
            self.numeroJogadoresUILabel.text = "\(number)/4"
            self.playersNumber = number
            for index in 0 ..< number {
                let image = UIImage(named: "lobby\(index)")
                if ServiceManager.peerID.pid != index {
                    self.playersLabel[index].text = self.playersName[index]
                } else {
                    self.playersLabel[index].text = "Me"
                }
                self.playersImageView[index].image = image
            }
        }
    }
    
    func startGame() {
        performSegue(withIdentifier: "begin", sender: nil)
    }
    
    func send(_ value: String) {
        guard let data = value.data(using: .utf8) else { return }
        do {
            guard let session = serviceManager?.session else { return }
            try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        } catch {
            print(error)
        }
    }
}

