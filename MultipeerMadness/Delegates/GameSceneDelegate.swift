//
//  GameSceneDelegate.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 22/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneDelegate {
    func createEntities(quantity: Int)
    func add(_ entity: GKEntity)
    func addNode(_ node: SKNode)
    func remove(_ entity: GKEntity)
    func move(onIndex index: Int, by values: (CGFloat, CGFloat))
    func move(onIndex index: Int, to pos: (CGFloat, CGFloat))
    func setVelocity(_ v: [CGFloat], on index: Int)
    func setRotation(_ r: CGFloat, on index: Int)
    func announceShooting(on index: Int)
    func announceStop(on index: Int)
    func send(_ value: String)
    func updateKills(to killCount: Int)
}

extension GameScene: SceneDelegate {
    
    
    
    func send(_ value: String) {
        guard let data = value.data(using: .utf8) else { return }
        do {
            guard let session = session else { return }
            try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        } catch {
            NSLog("Erro ao carregar SESSION de Multipier\(error)")
        }
    }
    
    func add(_ entity: GKEntity) {
        entityManager.add(entity)
    }
    
    func addNode(_ node: SKNode) {
        addChild(node)
    }
    
    func remove(_ entity: GKEntity) {
        entityManager.remove(entity)
    }
    
    func createEntities(quantity: Int) {
        if self.players.count < quantity {
            for i in self.players.count ..< quantity {
                let player = Player(imageName: "idle_nothing_front_\(i)", sceneDelegate: self)
                players.append(player)
                add(player)
            }
        }
    }
    
    func move(onIndex index: Int, by values: (CGFloat, CGFloat)) {
        if index < players.count {
            guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
            playerNode.position.x -= values.0
            playerNode.position.y += values.1
        }
    }
    
    func move(onIndex index: Int, to pos: (CGFloat, CGFloat)) {
        if index < players.count {
            guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
            playerNode.position.x = pos.0 * UIScreen.main.bounds.width
            playerNode.position.y = pos.1 * UIScreen.main.bounds.height
        }
    }
    
    func setVelocity(_ v: [CGFloat], on index: Int) {
        var velocity: VelocityComponent? = nil
        if index >= 0 && index < self.players.count {
            velocity = players[index].component(ofType: VelocityComponent.self)
        }
        velocity?.x = v[0]
        velocity?.y = v[1]
    }
    
    func setRotation(_ r: CGFloat, on index: Int) {
        guard let playerSprite = players[index].component(ofType: SpriteComponent.self) else { return }
        playerSprite.animateRun(to: r, index)
    }
    
    func announceShooting(on index: Int) {
        
        players[index].shoot(index: index, zRotation: joystick.getZRotation())
    }
    
    func updateKills(to killCount: Int) {
        scoreLabel?.text = "Kills: \(killCount)"
        if killCount == 10 {
            send("winner:\(ServiceManager.peerID.pid)")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameOver"), object: nil, userInfo: ["winner": ServiceManager.peerID.pid])
        }
    }
    
    func announceStop(on index: Int) {
        guard let playerSprite = players[index].component(ofType: SpriteComponent.self) else { return }
        playerSprite.animateIdle(to: playerSprite.node.zRotation, index)
    }
}
