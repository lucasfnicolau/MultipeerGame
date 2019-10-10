//
//  GameScene.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 08/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

protocol SceneDelegate {
    func addNodes(quantity: Int)
    func move(onIndex index: Int, by values: (CGFloat, CGFloat))
}

class GameScene: SKScene {
    
    var joystick: Joystick = Joystick()
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    var circles = [SKShapeNode]()
    var colors: [UIColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)]
    
    var session: MCSession?
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        joystick = Joystick(radius: 50, in: self)
        addChild(joystick)

        joystick.position = CGPoint(x: -UIScreen.main.bounds.width / 3.3,
                                    y: -UIScreen.main.bounds.height / 4)
    }
    
    func addPlayer(index: Int) {
        let circle = SKShapeNode(circleOfRadius: 20)
        circle.fillColor = colors[index]
        circles.append(circle)
        addChild(circle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            joystick.setNewPosition(withLocation: location)
            joystick.activo = true
            joystick.show()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let first = touches.first else { return }
        let location = first.location(in: self)
        let index = ServiceManager.peerID.pid
        
        if index >= 0 && index < self.circles.count {
            
            if joystick.activo == true {
                let dist = joystick.getDist(withLocation: location)

                circles[index].zRotation = joystick.getZRotation()

                joystick.vX = dist.xDist / 16
                joystick.vY = dist.yDist / 16
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            joystick.coreReturn()
            joystick.activo = false
            joystick.vX = 0
            joystick.vY = 0
            joystick.hiden()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            joystick.coreReturn()
            joystick.activo = false
            joystick.vX = 0
            joystick.vY = 0
            joystick.hiden()
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        let index = ServiceManager.peerID.pid
        
        deltaTime = currentTime - lastTime
        
        if joystick.activo == true && index >= 0 && index < self.circles.count {
            circles[index].position = CGPoint(x: circles[index].position.x - (joystick.vX),
                                              y: circles[index].position.y + (joystick.vY))
            
            let x = String(format: "%.0f", self.circles[index].position.x)
            let y = String(format: "%.0f", self.circles[index].position.y)

            guard let data = "\(index):\(x):\(y)".data(using: .utf8) else { return }
            do {
                guard let session = session else { return }
                try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
            } catch {
                print(error)
            }
        }
        
        lastTime = currentTime
    }
}

extension GameScene: SceneDelegate {
    func addNodes(quantity: Int) {
        if self.circles.count < quantity {
            for index in self.circles.count ... quantity {
                let circle = SKShapeNode(circleOfRadius: 20)
                circle.fillColor = colors[index]
                circles.append(circle)
                addChild(circle)
            }
        }
    }
    
    func move(onIndex index: Int, by values: (CGFloat, CGFloat)) {
        self.circles[index].position.x = values.0
        self.circles[index].position.y = values.1
    }
}
