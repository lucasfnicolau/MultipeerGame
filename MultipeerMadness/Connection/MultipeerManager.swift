//
//  MultipeerManager.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 09/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import MultipeerConnectivity

class MultipeerManager {
    
    static var peerID: CustomMCPeerID!
    static var mcSession: MCSession!
    static var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    static func start(withDelegate delegate: GameViewController) {
        MultipeerManager.peerID = CustomMCPeerID(displayName: UIDevice.current.name)
        MultipeerManager.mcSession = MCSession(peer: MultipeerManager.peerID, securityIdentity: nil, encryptionPreference: .none)
        MultipeerManager.mcSession.delegate = delegate
    }
    
    static func startSession() {
        MultipeerManager.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: Service.multiplayerGame.rawValue, discoveryInfo: nil, session: MultipeerManager.mcSession)
        MultipeerManager.mcAdvertiserAssistant.start()
        MultipeerManager.peerID.pid = 0
    }
}
