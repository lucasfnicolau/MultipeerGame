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
    func addNodes(quantity: Int)
    func move(onIndex index: Int, by values: (CGFloat, CGFloat))
    func setVelocity(_ v: [CGFloat], on index: Int)
}

class GameScene: SKScene {
    
    var joystick: Joystick = Joystick()
    var lastTime: TimeInterval = TimeInterval()
    var deltaTime: TimeInterval = TimeInterval()
    
    var circles = [SKShapeNode]()
    var lastVelocity: [CGFloat] = [0, 0]
    var velocities: [[CGFloat]] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
    var colors: [UIColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)]
    
    var session: MCSession?
    
    override func didMove(to view: SKView) {
        ObserveForGameControllers()
        connectControllers()
        
        backgroundColor = .white
        
        joystick = Joystick(radius: 50, in: self)
        addChild(joystick)

        joystick.position = CGPoint(x: -UIScreen.main.bounds.width / 3.3,
                                    y: -UIScreen.main.bounds.height / 4)
    }
    
    // Function to run intially to lookout for any MFI or Remote Controllers in the area
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    // This Function is called when a controller is connected to the Apple TV
    @objc func connectControllers() {
        //Unpause the Game if it is currently paused
        self.isPaused = false
        //Used to register the Nimbus Controllers to a specific Player Number
        var indexNumber = 0
        // Run through each controller currently connected to the system
        for controller in GCController.controllers() {
            //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                setupControllerControls(controller: controller)
            }
        }
    }
    
    // Function called when a controller is disconnected from the Apple TV
    @objc func disconnectControllers() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }
    
    func setupControllerControls(controller: GCController) {
        //Function that check the controller when anything is moved or pressed on it
        controller.extendedGamepad?.valueChangedHandler = {
        (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // Add movement in here for sprites of the controllers
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
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
                
                velocities[index] = [joystick.vX, joystick.vY]
                
                if joystick.vX != lastVelocity[0]
                    || joystick.vY != lastVelocity[1] {
                    
                    self.send("v:\(ServiceManager.peerID.pid):\(String(format: "%.2f", joystick.vX)):\(String(format: "%.2f", joystick.vY))")
                    
                }
                
                lastVelocity[0] = joystick.vX
                lastVelocity[1] = joystick.vY
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
            
            send("v:\(ServiceManager.peerID.pid):0:0")
            
            setVelocity([0, 0], on: ServiceManager.peerID.pid)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystick.activo == true {
            joystick.coreReturn()
            joystick.activo = false
            joystick.vX = 0
            joystick.vY = 0
            joystick.hiden()
            
            send("v:\(ServiceManager.peerID.pid):0:0")
            setVelocity([0, 0], on: ServiceManager.peerID.pid)
        }
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
        
        if index >= 0 && index < self.circles.count {
            
            for i in 0 ..< circles.count {
                circles[i].position = CGPoint(x: circles[i].position.x - velocities[i][0],
                                              y: circles[i].position.y + velocities[i][1])
            }
            
//            let x = String(format: "%.0f", self.circles[index].position.x)
//            let y = String(format: "%.0f", self.circles[index].position.y)
//
//            guard let data = "\(index):\(x):\(y)".data(using: .utf8) else { return }
//            do {
//                guard let session = session else { return }
//                try session.send(data, toPeers: session.connectedPeers, with: .unreliable)
//            } catch {
//                print(error)
//            }
        }
        
        lastTime = currentTime
    }
}

extension GameScene: SceneDelegate {
    
    func addNodes(quantity: Int) {
        if self.circles.count <= quantity {
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
    
    func setVelocity(_ v: [CGFloat], on index: Int) {
        velocities[index] = v
    }
}
