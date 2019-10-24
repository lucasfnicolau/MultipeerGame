//
//  Player.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 17/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import GameplayKit

class Player: GKEntity, Shooter {
    
    var isEnabled = true
    var sceneDelegate: SceneDelegate?
    var ammo = 3
    static let bitmask: UInt32 = 0001
    var dashIsAvailable = true
    var kills = 0 {
        didSet {
            sceneDelegate?.updateKills(to: self.kills)
        }
    }
    
    init(imageName: String, sceneDelegate: SceneDelegate? = nil) {
        super.init()
        
        self.sceneDelegate = sceneDelegate
        let texture = TextureManager.shared.getTextureAtlasFrames(for: imageName)[0]
        
        let spriteComponent = SpriteComponent(texture: texture, owner: self)
//        guard let texture = spriteComponent.node.texture else { return }
        spriteComponent.node.setScale(0.05)
        spriteComponent.node.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width / 4)
        spriteComponent.node.physicsBody?.isDynamic = false
        spriteComponent.node.physicsBody?.categoryBitMask = Player.bitmask
//        spriteComponent.node.physicsBody?.collisionBitMask = Floor.bitmask
        spriteComponent.node.physicsBody?.contactTestBitMask = Bullet.bitmask
        addComponent(spriteComponent)
        
        let velocity = VelocityComponent()
        addComponent(velocity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(index: Int) {
        if ammo > 0 && isEnabled {
            let bullet = Bullet(imageName: "bullet", sceneDelegate: sceneDelegate, owner: self)
            guard let bulletNode = bullet.component(ofType: SpriteComponent.self)?.node else { return }
            bulletNode.setScale(0.08)
            
            guard let spriteNode = self.component(ofType: SpriteComponent.self) else { return }
            let x = spriteNode.node.position.x
            let y = spriteNode.node.position.y
            
            spriteNode.animateShoot(to: spriteNode.node.zRotation, index)
            
            bulletNode.position = CGPoint(x: x, y: y)
            bulletNode.name = "bullet"
            
            bullet.fire(basedOn: spriteNode.node.zRotation + .pi)

            
            ammo -= 1
            if ammo == 0 {
                perform(#selector(reload), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    @objc func reload() {
        if ammo == 0 {
            ammo = 3
        }
    }
    
    func dash() {
        if dashIsAvailable && isEnabled {
            guard self.component(ofType: VelocityComponent.self) != nil else { return }
            
            let animationDuration: TimeInterval = 1

            var actionArray = [SKAction]()
            
            guard let playerNode = self.component(ofType: SpriteComponent.self)?.node else { return }
            
            let rotation = playerNode.zRotation
            let radius = UIScreen.main.bounds.width / 2.0
            
            let xDist: CGFloat = -(sin(rotation - .pi / 2) * radius / 2.5)
            let yDist: CGFloat = cos(rotation - .pi / 2) * radius / 2.5
            
            actionArray.append(SKAction.move(by: CGVector(dx: xDist, dy: yDist), duration: animationDuration))
            playerNode.run(SKAction.sequence(actionArray))
            
            dashIsAvailable = false
            perform(#selector(enableDash), with: nil, afterDelay: 3)
        }
    }
    
    @objc func enableDash() {
        dashIsAvailable = true
    }
    
    func die() {
        sceneDelegate?.remove(self)
        isEnabled = false
        perform(#selector(respawn), with: nil, afterDelay: 1.0)
    }
    
    @objc func respawn() {
        guard let node = self.component(ofType: SpriteComponent.self)?.node else { return }
        node.position.x = 0
        node.position.y = 0
        sceneDelegate?.addNode(node)
        isEnabled = true
    }
}
