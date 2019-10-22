//
//  GameSceneContactDelegate.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 21/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let player = players[ServiceManager.peerID.pid]
        guard let playerNode = player.component(ofType: SpriteComponent.self)?.node,
            let firstNode = firstBody.node,
            let secondNode = secondBody.node else { return }
        
        if playerNode != firstNode {
            print("pew pew")
            destroy([firstNode, secondNode])
        } else {
            destroy([playerNode, secondNode])
        }
    }
    
    func destroy(_ nodes: [SKNode]) {
        nodes.forEach { (node) in
            node.removeFromParent()
        }
    }
}
