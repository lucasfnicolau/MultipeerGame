//
//  SpriteComponent.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 16/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    let node: CustomNode
    var lastMoved: String = ""
    var owner: GKEntity?
    var state: String = ""
    
    init(texture: SKTexture, owner: GKEntity) {
        node = CustomNode(texture: texture, color: .white, size: texture.size(), owner: owner)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateRun(to zRotation: CGFloat, _ index: Int) {
        node.zRotation = zRotation - .pi / 2
        let direction = getDirection(zRotation: zRotation)
        animateTo(state: "run", action: "nothing", direction: direction, player: index)
    }
    
    func animateShoot(to zRotation: CGFloat, _ index: Int) {
        node.zRotation = zRotation - .pi / 2
        let direction = getDirection(zRotation: zRotation)
        animateTo(state: "run", action: "shooting", direction: direction, player: index)
    }
    
    func getDirection(zRotation: CGFloat) -> String {
        
        // 0.5 == 90 graus
        
        switch zRotation / .pi {
        case -0.125 ..< 0.125:
            return ("back")
            
        case -0.375 ..< -0.125:
            return ("back_right")
            
        case -0.625 ..< -0.375:
            return ("right")
            
        case -0.875 ..< -0.625:
            return ("front_right")
            
        case -1.125 ..< -0.875:
            return ("front")
            
        case -1.375 ..< -1.125:
            return ("front_left")
            
        case -1.5 ..< -1.375:
            return ("left")
            
        case 0.375 ..< 0.5:
            return ("left")
            
        case 0.125 ..< 0.375:
            return ("back_left")
            
        default:
            return ("RUIM")
            
        }
    }
    
    private func animateTo(state: String, action: String, direction: String, player: Int) {
        let position = "\(state)_\(action)_\(direction)_\(player)"
        
        if lastMoved != position {
            let texture = TextureManager.shared.getTextureAtlasFrames(for: position)
            if texture.count > 0 {
                if action == "shooting" {
                    animateFrames(in: node, with: texture)
                } else  {
                    animateFramesForever(in: node, with: texture)
                }
                
                lastMoved = position
            } else {
                NSLog("ERRO: Falha ao carregar os frames.")
            }
            
        }
    }
    
    private func animateFrames(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        obj.run(animate, withKey: "moved")
    }
    
    private func animateFramesForever(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
    
    
    
}
