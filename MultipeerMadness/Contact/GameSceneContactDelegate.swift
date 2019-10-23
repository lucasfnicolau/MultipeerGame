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
        
        guard let playerShot: CustomNode = firstBody.node as? CustomNode,
            let bulletNode: CustomNode = secondBody.node as? CustomNode else { return }
        
        for player in players {
            guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }

            if playerNode == playerShot {
                destroy([playerShot, bulletNode])
                player.die()
            }
        }
        
        guard let bullet: Bullet = bulletNode.owner as? Bullet,
        let owner: Player = bullet.owner else { return }
        let player = players[ServiceManager.peerID.pid]
        
        if owner == player {
            player.kills += 1
        }
    }
    
    func destroy(_ nodes: [SKNode]) {
        nodes.forEach { (node) in
            node.removeFromParent()
        }
    }
}
