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
    var name = ""
    @IBOutlet weak var numeroJogadoresUILabel: UILabel!
    
    @IBOutlet weak var jogadorUmUILabel: UILabel!
    @IBOutlet weak var jogadorUmImagem: UIImageView!
    
    @IBOutlet weak var jogadorDoisUILabel: UILabel!
    @IBOutlet weak var jogadorDoisImagem: UIImageView!
    
    @IBOutlet weak var jogadorTresImagem: UIImageView!
    @IBOutlet weak var jogadorTresUILabel: UILabel!

    @IBOutlet weak var jogadorQuatroUILabel: UILabel!
    
    @IBOutlet weak var jogadorQuatroImagem: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
//    
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
