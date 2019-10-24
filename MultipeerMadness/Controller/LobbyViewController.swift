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
    @IBOutlet weak var jogadorUmUILabel: UILabel!
    @IBOutlet weak var jogadorUmImagem: UIImageView!
    @IBOutlet weak var jogadorDoisUILabel: UILabel!
    @IBOutlet weak var jogadorDoisImagem: UIImageView!
    @IBOutlet weak var jogadorTresImagem: UIImageView!
    @IBOutlet weak var jogadorTresUILabel: UILabel!
    @IBOutlet weak var jogadorQuatroUILabel: UILabel!
    @IBOutlet weak var jogadorQuatroImagem: UIImageView!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var sairUIButton: UIButton!
    @IBOutlet weak var beginUIButton: UIButton!
    @IBOutlet weak var readyUIButton: UIButton!
    var prontos: [Bool] = []
    var name = ""
    let serviceManager = ServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         beginUIButton.setTitle("Pronto", for: .normal)
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
        if readyUIButton.isEnabled{
            readyUIButton.isEnabled = false
            for n in 0..<prontos.count {
                if !prontos[n] {
                    prontos[n] = true
                    break
                }
            }
            
        } else{
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
        
        for pronto in prontos {
            if pronto == false {
                print("nem todos os jogadores estão prontos!")
                break
            }
        }

    }
    
    func startGame(){
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? GameViewController {
                vc.modalPresentationStyle = .fullScreen
                    vc.name = "host"
            }
        }
    }
    @IBAction func quitAction(_ sender: Any) {
        //função de encerrar a conexão multipeer
    }
}

