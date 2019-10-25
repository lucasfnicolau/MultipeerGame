//
//  Joystick.swift
//  joystick
//
//  Created by Matheus Silva on 09/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit

class Joystick: SKShapeNode {
    
    public var activo: Bool = false
    
    private(set) var radius: CGFloat = 0
    private(set) var child: SKShapeNode = SKShapeNode()
    
    private(set) var vector: CGVector = CGVector()
    private(set) var angle: CGFloat = 0
    private(set) var raio: CGFloat = 0
    
    private var radius90: CGFloat = .pi / 2
    
    public var vX: CGFloat = 0
    public var vY: CGFloat = 0
    
    override init() {
        super.init()
    }

    convenience init(radius: CGFloat, in scene: SKScene) {
        self.init()
        self.radius = radius
        createJoystickBase()
        createJoystickBaseMain()
        scene.addChild(child)
        hiden()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createJoystickBase() {
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius),
                                             size:   CGSize(width: radius * 2, height: radius * 2)),
                                             transform: nil)
        self.strokeColor = .black
        self.alpha = 0.2
        self.lineWidth = 0.0
        self.zPosition = 1.0
    }
    
    private func createJoystickBaseMain() {
        child = SKShapeNode(circleOfRadius: radius / 2)
        child.strokeColor = .black
        child.alpha = 0.3
        child.lineWidth = 0.0
        child.zPosition = 2.0
    }
    
    public func setNewPosition(withLocation location: CGPoint) {
        self.position = location
        self.child.position = location
    }
    
    public func getDist(withLocation location: CGPoint) -> (xDist: CGFloat, yDist: CGFloat) {
        
        vector = CGVector(dx: location.x - self.position.x,
                          dy: location.y - self.position.y)
        angle = atan2(vector.dy, vector.dx)
        raio = self.frame.size.height / 2.0
        
        let xDist: CGFloat = sin(angle - radius90) * raio
        let yDist: CGFloat = cos(angle - radius90) * raio
        
        if (self.frame.contains(location)) {
            self.child.position = location
        } else {
            self.child.position = CGPoint(x: self.position.x - xDist,
                                          y: self.position.y + yDist)
        }
        
        return (xDist: xDist, yDist: yDist)
    }
    
    public func coreReturn() { //REMAKE - Mudar nome da funcao para ter mais coerencia.
        let retorno: SKAction = SKAction.move(to: self.position, duration: 0.05)
        retorno.timingMode = .easeOut
        child.run(retorno)
        activo = false
    }
    
    public func getZRotation() -> CGFloat {
        return angle - radius90
    }
    
    public func hiden() {
        self.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 0.0, duration: 0.5))
    }
    
    public func show() {
        self.run(SKAction.fadeAlpha(to: 0.2, duration: 0.5))
        self.child.run(SKAction.fadeAlpha(to: 0.3, duration: 0.5))
    }
    
    public func reset() {
        coreReturn()
        activo = false
        vX = 0
        vY = 0
        hiden()
    }
    
    public func update(withLocation location: CGPoint) {
       
        vector = CGVector(dx: location.x - self.position.x,
                          dy: location.y - self.position.y)
        angle = atan2(vector.dy, vector.dx)
        raio = self.frame.size.height / 2.0
        
        let xDist: CGFloat = sin(angle - radius90) * raio
        let yDist: CGFloat = cos(angle - radius90) * raio
        
        if (self.frame.contains(location)) {
            self.child.position = location
        } else {
            self.child.position = CGPoint(x: self.position.x - xDist,
                                          y: self.position.y + yDist)
            
        }
    }
}
