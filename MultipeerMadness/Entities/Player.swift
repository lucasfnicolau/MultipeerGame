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
    static let bitmask: UInt32 = 0x1
    var dashIsAvailable = true
    var kills = 0 {
        didSet {
            sceneDelegate?.updateKills(to: self.kills)
        }
    }
    let timeOfRespawn = 3.0
    
    init(imageName: String, sceneDelegate: SceneDelegate? = nil) {
        super.init()
        
        self.sceneDelegate = sceneDelegate
        let texture = TextureManager.shared.getTextureAtlasFrames(for: imageName)[0]
        
        let spriteComponent = SpriteComponent(texture: texture, owner: self)
        let node = spriteComponent.node
        node.zPosition = 1000
        node.setScale(Scale.player)
        let size = node.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        var origin = node.position
        origin.x -= node.size.width / 6
        origin.y -= node.size.height / 3
        node.physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRect(origin: origin, size: CGSize(width: size.width / 1.2, height: size.height * 1.2)), transform: nil))
        node.physicsBody?.categoryBitMask = Player.bitmask
        node.physicsBody?.collisionBitMask = CustomMap.normalBitmask
        //Ao inves de criar o contato ele o cria apos 3 segundos
        spawn(node: node) //node.physicsBody?.contactTestBitMask = Bullet.bitmask | CustomMap.hazardBitmask
        addComponent(spriteComponent)
        
        let velocity = VelocityComponent()
        addComponent(velocity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(index: Int, zRotation: CGFloat) {
        if ammo > 0 && isEnabled {
            let bullet = Bullet(imageName: "bullet\(index)", sceneDelegate: sceneDelegate, owner: self)
            guard let bulletNode = bullet.component(ofType: SpriteComponent.self)?.node else { return }
            bulletNode.setScale(Scale.bullet)
            
            guard let spriteNode = self.component(ofType: SpriteComponent.self) else { return }
            let x = spriteNode.node.position.x
            let y = spriteNode.node.position.y
            
            spriteNode.animateRunShoot(to: zRotation, index)
            
            bulletNode.position = CGPoint(x: x, y: y)
            bulletNode.name = "bullet"
            
            bullet.fire(basedOn: zRotation)
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
    
    func dash(zRotation: CGFloat) {
        if dashIsAvailable && isEnabled {
            guard self.component(ofType: VelocityComponent.self) != nil else { return }
            
            let animationDuration: TimeInterval = 1

            var actionArray = [SKAction]()
            
            guard let playerNode = self.component(ofType: SpriteComponent.self)?.node else { return }
            
            let radius = UIScreen.main.bounds.width / 2.0
            
            let xDist: CGFloat = sin(zRotation) * radius / 2
            let yDist: CGFloat = cos(zRotation) * radius / 2
            
            actionArray.append(SKAction.move(by: CGVector(dx: -xDist, dy: yDist), duration: animationDuration))
            playerNode.run(SKAction.sequence(actionArray))
            
            dashIsAvailable = false
            perform(#selector(enableDash), with: nil, afterDelay: 3)
        }
    }
    
    @objc func enableDash() {
        dashIsAvailable = true
    }
    
    func die(index: Int) {
        self.isEnabled = false
        guard let spriteComponent = self.component(ofType: SpriteComponent.self) else { return }
        guard let velocity = self.component(ofType: VelocityComponent.self) else { return }
        velocity.x = 0
        velocity.y = 0
        spriteComponent.state = "die"
        
        self.perform(#selector(self.respawn(argument:)), with: index, afterDelay: 1.0)
        self.sceneDelegate?.remove(self)
        
        spriteComponent.lastMoved = ""
        spriteComponent.animateDie(index: index)
        
        if let nodeCopy = spriteComponent.node.copy() as? CustomNode {
            nodeCopy.zPosition = 10
            nodeCopy.physicsBody = nil
            sceneDelegate?.addNode(nodeCopy)
        }
    }
    
    @objc func respawn(argument: Any) {
        guard let index = argument as? Int else { return }
        guard let spriteComponent = self.component(ofType: SpriteComponent.self) else { return }
        spriteComponent.state = ""
        sceneDelegate?.enableJoystick()
        spriteComponent.animateIdle(to: -1, index)
        
        let node = spriteComponent.node
        node.position = CGPoint.zero
        
        spawn(node: node)

        sceneDelegate?.addNode(node)
        isEnabled = true
    }
    
    private func spawn(node: CustomNode) {
        node.physicsBody?.contactTestBitMask = 0
        let sequence = [SKAction.fadeOut(withDuration: 0.5),
                        SKAction.fadeIn(withDuration: 0.5)]
        node.run(SKAction.repeat(SKAction.sequence(sequence), count: Int(timeOfRespawn)))
        self.perform(#selector(self.stateRespawn(argument:)), with: node, afterDelay: timeOfRespawn)
    }
    
    @objc func stateRespawn(argument: Any) {
        guard let node = argument as? CustomNode else { return }
        node.physicsBody?.contactTestBitMask = Bullet.bitmask | CustomMap.hazardBitmask
    }
    
}
