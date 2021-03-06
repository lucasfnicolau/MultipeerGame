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
        
        if firstBody.categoryBitMask == CustomMap.normalBitmask {
            guard let node = secondBody.node else { return }
            destroy([node])
            
        } else if secondBody.categoryBitMask == CustomMap.hazardBitmask {
            guard let playerNode: CustomNode = firstBody.node as? CustomNode else { return }
            destroy([])
            
            guard let player = findPlayer(basedOn: playerNode) else { return }
            guard let index = players.firstIndex(of: player) else { return }
            player.die(index: index)
            DispatchQueue.main.async {
                self.killAudioPlayer?.play()
            }
            
            let myPlayer = players[ServiceManager.peerID.pid]
            
            if player == myPlayer {
                joystick.activo = false
                joystick.reset()
                shootBtn.isEnabled = false
                dashBtn.isEnabled = false
            }
            
        } else {
            guard let playerShot: CustomNode = firstBody.node as? CustomNode,
                let bulletNode: CustomNode = secondBody.node as? CustomNode else { return }
            
            destroy([bulletNode])
            
            guard let player = findPlayer(basedOn: playerShot) else { return }
            guard let index = players.firstIndex(of: player) else { return }
            player.die(index: index)
            DispatchQueue.main.async {
                self.killAudioPlayer?.play()
            }
            
            guard let bullet: Bullet = bulletNode.owner as? Bullet,
            let owner: Player = bullet.owner else { return }
            let myPlayer = players[ServiceManager.peerID.pid]
            
            if player == myPlayer {
                joystick.activo = false
                joystick.reset()
                shootBtn.isEnabled = false
                dashBtn.isEnabled = false
            }
            
            if owner == myPlayer {
                myPlayer.kills += 1
            }
        }
    }
    
    func findPlayer(basedOn node: CustomNode) -> Player? {
        for player in players {
            guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return nil }
            if playerNode == node {
                return player
            }
        }
        return nil
    }
    
    func destroy(_ nodes: [SKNode]) {
        nodes.forEach { (node) in
            node.removeFromParent()
        }
    }
}
