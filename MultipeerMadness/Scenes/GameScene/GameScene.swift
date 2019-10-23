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

class GameScene: SKScene {
    
    var joystick: Joystick = Joystick()
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    var players = [Player]()
    var session: MCSession?
    var entityManager: EntityManager!
    var map = CustomMap()
    var shootButton = UIButton()
    var uiFactory: UIFactory!
    var scoreLabel: UILabel?
    let playerCamera = SKCameraNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        playerCamera.name = "playerCamera"
        self.camera = playerCamera
        
        entityManager = EntityManager(scene: self)
        
        map = CustomMap(namedTile: "Map", tileSize: CGSize(width: 128, height: 128))
        map.setScale(0.4)
        addChild(map)
        
        ObserveForGameControllers()
        connectControllers()
        
        joystick = Joystick(radius: 50, in: self)
        addChild(joystick)
        
        uiFactory = UIFactory(scene: self)
        uiFactory.createButton(ofType: "shoot")
        uiFactory.createButton(ofType: "dash")
        scoreLabel = uiFactory.createLabel(ofType: "score")
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
        guard let first = touches.first else { return }
        let location = first.location(in: self)
        let index = ServiceManager.peerID.pid
        
        if location.x <= 0 && index >= 0 && index < self.players.count
            && joystick.activo == true {
            
            let dist = joystick.getDist(withLocation: location)

            guard let playerSprite = players[index].component(ofType: SpriteComponent.self) else { return }
            let rotation = String(format: "%.5f", joystick.getZRotation()).cgFloat()
            playerSprite.runTo(zRotation: joystick.getZRotation())

            joystick.vX = dist.xDist / 16
            joystick.vY = dist.yDist / 16
            
            guard let velocity = players[index].component(ofType: VelocityComponent.self) else { return }
            var joyVel = CGPoint(x: joystick.vX, y: joystick.vY)
            joyVel.normalize()
            
            velocity.x = String(format: "%.5f", joyVel.x).cgFloat()
            velocity.y = String(format: "%.5f", joyVel.y).cgFloat()
            
            self.send("v:\(index):\(velocity.x):\(velocity.y):\(rotation)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        let location = first.location(in: self)
        
        if location.x <= 0 {
            if joystick.activo == true {
                reset()

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
        let index = ServiceManager.peerID.pid
        send("v:\(index):0:0:-")
        setVelocity([0, 0], on: index)
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        let index = ServiceManager.peerID.pid
        
        deltaTime = currentTime - lastTime
        
        if index >= 0 && index < self.players.count {

            guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node,
                let velocity = players[index].component(ofType: VelocityComponent.self) else { return }
            playerNode.position.x -= velocity.x * UIScreen.main.bounds.width
            playerNode.position.y += velocity.y * UIScreen.main.bounds.height
            
            playerCamera.position = playerNode.position
            
            var normalizedPos = playerNode.position
            normalizedPos.normalize()
            self.send("\(index):\(normalizedPos.x):\(normalizedPos.y)")
            
//            for i in 0 ..< players.count {
//                guard let playerNode = players[i].component(ofType: SpriteComponent.self)?.node,
//                    let velocity = players[i].component(ofType: VelocityComponent.self) else { return }
//                playerNode.position.x -= velocity.x
//                playerNode.position.y += velocity.y
//            }
        }
        
        lastTime = currentTime
    }
    
    @objc func shoot() {
        let index = ServiceManager.peerID.pid
        if index >= 0 && index < self.players.count {
            players[index].shoot()
            self.send("fire:\(index)")
        }
    }
    
    @objc func dash() {
        let index = ServiceManager.peerID.pid
        if index >= 0 && index < self.players.count {
            players[index].dash()
        }
    }
}
