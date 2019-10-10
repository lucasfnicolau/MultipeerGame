//
//  GameScene.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 08/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var joystick: Joystick!
    var circles = [SKShapeNode]()
    var colors: [UIColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)]
    
    override func didMove(to view: SKView) {
        joystick = Joystick(radius: 80, in: self)
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
            if (joystick.frame.contains(location)) {
                joystick.activo = true
            } else {
                joystick.activo = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let first = touches.first else { return }
        let location = first.location(in: self)
        let index = MultipeerManager.peerID.pid
        
        if index >= 0 && index < self.circles.count {
            
            if joystick.activo == true {
                let vector = CGVector(dx: location.x - joystick.position.x, dy: location.y - joystick.position.y)
                let angulo = atan2(vector.dy, vector.dx)
                let radio: CGFloat = joystick.frame.size.height / 2

                let xDist: CGFloat = sin(angulo - 1.57079633) * radio
                let yDist: CGFloat = cos(angulo - 1.57079633) * radio

                if (joystick.frame.contains(location)) {
                    joystick.child.position = location
                } else {
                    joystick.child.position = CGPoint(x: joystick.position.x - xDist, y: joystick.position.y + yDist)
                }

                circles[index].zRotation = angulo - 1.57079633

                joystick.vX = xDist / 16
                joystick.vY = yDist / 16
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            let backToOrigin: SKAction = SKAction.move(to: joystick.position, duration: 0.05)
            backToOrigin.timingMode = .easeOut
            joystick.child.run(backToOrigin)
            joystick.activo = false
            joystick.vX = 0
            joystick.vY = 0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            let backToOrigin: SKAction = SKAction.move(to: joystick.position, duration: 0.05)
            backToOrigin.timingMode = .easeOut
            joystick.child.run(backToOrigin)
            joystick.activo = false
            joystick.vX = 0
            joystick.vY = 0
        }
    }
    
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    override func update(_ currentTime: CFTimeInterval) {
        let index = MultipeerManager.peerID.pid
        
        deltaTime = currentTime - lastTime
        
        if joystick.activo == true && index >= 0 && index < self.circles.count {
            circles[index].position = CGPoint(x: circles[index].position.x - (joystick.vX),
                                            y: circles[index].position.y + (joystick.vY))
            
            let x = String.init(format: "%.0f", self.circles[index].position.x)
            let y = String.init(format: "%.0f", self.circles[index].position.y)

            guard let data = "\(index):\(x):\(y)".data(using: .utf8) else { return }
            do {
                try MultipeerManager.mcSession.send(data, toPeers: MultipeerManager.mcSession.connectedPeers, with: .unreliable)
            } catch {
                print(error)
            }
        }
        
        lastTime = currentTime
    }
}
