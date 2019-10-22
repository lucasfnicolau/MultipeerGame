//
//  Bullet.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 17/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import GameplayKit

class Bullet: GKEntity {
    static let bitmask: UInt32 = 0010
    
    init(imageName: String) {
        super.init()

        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        guard let texture = spriteComponent.node.texture else { return }
        spriteComponent.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        spriteComponent.node.physicsBody?.categoryBitMask = Bullet.bitmask
//        spriteComponent.node.physicsBody?.collisionBitMask = Floor.bitmask
        spriteComponent.node.physicsBody?.contactTestBitMask = Player.bitmask
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(basedOn rotation: CGFloat) {

        guard let node = self.component(ofType: SpriteComponent.self)?.node else { return }

        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        
        let animationDuration: TimeInterval = 5

        var actionArray = [SKAction]()
        
        let radius = UIScreen.main.bounds.width / 2.0
        
        let xDist: CGFloat = sin(rotation - .pi / 2) * radius / 5
        let yDist: CGFloat = cos(rotation - .pi / 2) * radius / 5
        
        actionArray.append(SKAction.applyImpulse(CGVector(dx: -xDist, dy: yDist), at: node.position, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        node.run(SKAction.sequence(actionArray))
    }
}
