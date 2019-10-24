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
    
    @IBOutlet weak var numeroJogadoresUILabel: UILabel!
    @IBOutlet weak var sairUIButton: UIButton!
    @IBOutlet weak var beginUIButton: UIButton!
    @IBOutlet weak var readyUIButton: UIButton!
    @IBOutlet var playersImageView: [UIImageView]!
    @IBOutlet var playersLabel: [UILabel]!
    var prontos: [Bool] = []
    var name = ""
    var playersName = ["Jack", "Loke", "Kate", "Claire"]
    let serviceManager = ServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceManager.lobbyDelegate = self
        
        if name == "host" {
            serviceManager.createSession()
            ServiceManager.peerID.pid = 0
            readyUIButton.isHidden = true
        } else {
            serviceManager.enterSession()
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
        var allReady = true
        for pronto in prontos {
            if pronto == false {
                allReady = false
                print("nem todos os jogadores estão prontos!")
                break
            }
        }
        
        if allReady {
            send("start:")
            self.performSegue(withIdentifier: "begin", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.serviceManager = serviceManager
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LobbyViewController: LobbyDelegate {
    func updatePlayers(to number: Int) {
        DispatchQueue.main.async {
            self.numeroJogadoresUILabel.text = "\(number)/4"
            for index in 0 ..< number {
                let image = UIImage(named: "idle_nothing_front_\(index)0")
                if ServiceManager.peerID.pid != index {
                    self.playersLabel[index].text = self.playersName[index]
                } else {
                    self.playersLabel[index].text = "Me"
//                    self.playersLabel[index].textColor = 
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
            let session = serviceManager.session
            try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        } catch {
            print(error)
        }
    }
}

