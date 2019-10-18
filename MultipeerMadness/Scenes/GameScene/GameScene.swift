//
//  GameScene.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 08/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import MultipeerConnectivity

protocol SceneDelegate {
    func createEntities(quantity: Int)
    func add(_ entity: GKEntity)
    func move(onIndex index: Int, by values: (CGFloat, CGFloat))
    func setVelocity(_ v: [CGFloat], on index: Int)
    func setRotation(_ r: CGFloat, on index: Int)
    func announceShooting(on index: Int)
}

class GameScene: SKScene {
    
    var joystick: Joystick = Joystick()
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    var players = [Player]()
    var lastVelocity: [CGFloat] = [0, 0]
    var session: MCSession?
    var entityManager: EntityManager!
    var map = CustomMap()
    
    override func didMove(to view: SKView) {
        entityManager = EntityManager(scene: self)
        
        map = CustomMap(namedTile: "Map", tileSize: CGSize(width: 128, height: 128))
        map.setScale(0.4)
        addChild(map)
        
        ObserveForGameControllers()
        connectControllers()
        
        joystick = Joystick(radius: 50, in: self)
        addChild(joystick)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x <= 0 {
                joystick.setNewPosition(withLocation: location)
                joystick.activo = true
                joystick.show()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let index = ServiceManager.peerID.pid
            
            if location.x <= 0 && index >= 0 && index < self.players.count
                && joystick.activo == true {
                
                let dist = joystick.getDist(withLocation: location)

                guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
                playerNode.zRotation = joystick.getZRotation() + .pi/2

                joystick.vX = dist.xDist / 16
                joystick.vY = dist.yDist / 16
                
                guard let velocity = players[index].component(ofType: VelocityComponent.self) else { return }
//                var joyVel = CGPoint(x: joystick.vX, y: joystick.vY)
//                joyVel.normalize()
//                velocity.x = joyVel.x
//                velocity.y = joyVel.y
                velocity.x = String(format: "%.0f", joystick.vX).cgFloat()
                velocity.y = String(format: "%.0f", joystick.vY).cgFloat()
                
//                if joystick.vX != lastVelocity[0] || joystick.vY != lastVelocity[1] {
                    self.send("v:\(ServiceManager.peerID.pid):\(String(format: "%.0f", joystick.vX)):\(String(format: "%.0f", joystick.vY)):\(playerNode.zRotation)")
//                }
                
                lastVelocity[0] = joystick.vX
                lastVelocity[1] = joystick.vY
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x <= 0 {
                if joystick.activo == true {
                    reset()
                }
            } else {
                let index = ServiceManager.peerID.pid
                if index >= 0 && index < self.players.count {
                    players[index].shoot()
                    self.send("fire:\(index)")
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            reset()
        }
    }
    
    func reset() {
        joystick.reset()
        var playerNode: SKSpriteNode? = nil
        let index = ServiceManager.peerID.pid
        if index >= 0 && index < self.players.count {
            playerNode = players[index].component(ofType: SpriteComponent.self)?.node
        }
        send("v:\(index):0:0:\(playerNode?.zRotation ?? 0)")
        setVelocity([0, 0], on: ServiceManager.peerID.pid)
    }
    
    func send(_ value: String) {
        guard let data = value.data(using: .utf8) else { return }
        do {
            guard let session = session else { return }
            try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        } catch {
            print(error)
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        let index = ServiceManager.peerID.pid
        
        deltaTime = currentTime - lastTime
        
        if index >= 0 && index < self.players.count {
            
            for i in 0 ..< players.count {
                guard let playerNode = players[i].component(ofType: SpriteComponent.self)?.node else { return }
                guard let velocity = players[i].component(ofType: VelocityComponent.self) else { return }
                playerNode.position = CGPoint(x: playerNode.position.x - velocity.x,
                                              y: playerNode.position.y + velocity.y)
            }
        }
        
        lastTime = currentTime
    }
}

extension GameScene: SceneDelegate {
    
    func add(_ entity: GKEntity) {
        entityManager.add(entity)
    }
    
    func createEntities(quantity: Int) {
        if self.players.count <= quantity {
            for _ in self.players.count ... quantity {
                let player = Player(imageName: "player", sceneDelegate: self)
                players.append(player)
                add(player)
            }
        }
    }
    
    func move(onIndex index: Int, by values: (CGFloat, CGFloat)) {
        guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
        playerNode.position.x -= values.0
        playerNode.position.y += values.1
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
        guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
        playerNode.zRotation = r
    }
    
    func announceShooting(on index: Int) {
        players[index].shoot()
    }
}
