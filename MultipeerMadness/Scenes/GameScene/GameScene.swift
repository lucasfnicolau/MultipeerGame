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
    
    var xVariation: CGFloat?
    var yVariation: CGFloat?
    var lastTouch: CGPoint?
    
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
        let index = ServiceManager.peerID.pid
        
        for touch in touches {
            let locationScene = touch.location(in: self)
            let locationView = touch.location(in: self.view)
            
            if locationView.x <= UIScreen.main.bounds.width / 2 && index < players.count && index >= 0 {
                joystick.setNewPosition(withLocation: locationScene)
                joystick.activo = true
                joystick.show()
                
                guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else {
                    return
                }
                
                self.xVariation = playerNode.position.x - joystick.position.x
                self.yVariation = playerNode.position.y - joystick.position.y
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        let locationScene = first.location(in: self)
        let locationView = first.location(in: self.view)
        let index = ServiceManager.peerID.pid
        
        if locationView.x <= UIScreen.main.bounds.width / 2 && index >= 0 && index < self.players.count
            && joystick.activo == true {
            
            let dist = joystick.getDist(withLocation: locationScene)

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
            
            self.lastTouch = locationScene
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let first = touches.first else { return }
        let location = first.location(in: self.view)
        print("\(location) <<<<")
//        if location.x <= UIScreen.main.bounds.width / 2 {
            if joystick.activo == true {
                reset()
            }
//        }
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
    
    func setNewJoystickPosition(basedOn position: CGPoint) {
        
        guard let xVariation = self.xVariation,
            let yVariation = self.yVariation,
            let lastTouch = self.lastTouch else {
            return
        }
        
        let newX: CGFloat = position.x - xVariation
        let newY: CGFloat = position.y - yVariation
        let newPosition = CGPoint(x: newX, y: newY)
        
        joystick.position = newPosition
        joystick.setNewPosition(withLocation: newPosition)
        
        joystick.update(withLocation: lastTouch)
        
        
        
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
            
            setNewJoystickPosition(basedOn: playerNode.position)
            
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
