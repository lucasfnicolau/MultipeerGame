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
    static let bitmask: UInt32 = 0x1 << 1
    var sceneDelegate: SceneDelegate?
    var owner: Player?
    
    init(imageName: String, sceneDelegate: SceneDelegate?, owner: Player) {
        super.init()

        self.owner = owner
        self.sceneDelegate = sceneDelegate
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), owner: self)
        guard let texture = spriteComponent.node.texture else { return }
        spriteComponent.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        spriteComponent.node.physicsBody?.categoryBitMask = Bullet.bitmask
        spriteComponent.node.physicsBody?.collisionBitMask = CustomMap.normalBitmask
        spriteComponent.node.physicsBody?.contactTestBitMask = Player.bitmask | CustomMap.normalBitmask
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(basedOn rotation: CGFloat) {

        guard let node = self.component(ofType: SpriteComponent.self)?.node else { return }

        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        
        let animationDuration: TimeInterval = 5

        var actionArray = [SKAction]()
        
        let radius = UIScreen.main.bounds.width / 2.0
        
        let xDist: CGFloat = sin(rotation - .pi / 2) * radius / 5
        let yDist: CGFloat = cos(rotation - .pi / 2) * radius / 5
        
        node.position.x -= xDist
        node.position.y += yDist
        
        sceneDelegate?.add(self)
        actionArray.append(SKAction.move(by: CGVector(dx: -xDist * 35, dy: yDist * 35), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        node.run(SKAction.sequence(actionArray))
    }
}
