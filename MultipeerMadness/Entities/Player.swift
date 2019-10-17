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
    var sceneDelegate: SceneDelegate?
    var ammo = 3
    
    init(imageName: String, sceneDelegate: SceneDelegate? = nil) {
        super.init()
        
        self.sceneDelegate = sceneDelegate
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
        
        let velocity = VelocityComponent()
        addComponent(velocity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() {
        if ammo > 0 {
            let bullet = Bullet(imageName: "bullet")
            guard let bulletNode = bullet.component(ofType: SpriteComponent.self)?.node else { return }
            bulletNode.setScale(0.08)
            
            guard let node = self.component(ofType: SpriteComponent.self)?.node else { return }
            let x = node.position.x
            let y = node.position.y
            
            bulletNode.position = CGPoint(x: x, y: y)
            sceneDelegate?.add(bullet)
            
            bullet.fire(basedOn: node.zRotation)
            
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
}
