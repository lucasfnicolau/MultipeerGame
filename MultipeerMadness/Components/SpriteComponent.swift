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
    var direction: CGFloat = 0

    init(texture: SKTexture, owner: GKEntity) {
        node = CustomNode(texture: texture, color: .white, size: texture.size(), owner: owner)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runTo(zRotation: CGFloat) {
        // 0.5 = 90 graus
        // x = 0.5 / 2
        // y = 0.5 / 4
        let pid = ServiceManager.peerID.pid
        node.zRotation = zRotation
        
        switch zRotation / .pi {
            
            case -0.125 ..< 0.125:
                direction = 0
                print("N")
            
            case -0.375 ..< -0.125:
                print("NE")
                direction = -0.250
            
            case -0.625 ..< -0.375:
                print("L")
                direction = -0.5
            
            case -0.875 ..< -0.625:
                print("SE")
                direction = -0.5
            
            case -1.125 ..< -0.875:
                print("S")
                direction = -1
            
            case -1.375 ..< -1.125:
                print("SO")
                direction = -1.250
            
            case -1.5 ..< -1.375:
                print("O")
                direction = 0.5
                
            case 0.375 ..< 0.5:
                print("O")
                direction = 0.5
                
            case 0.125 ..< 0.375:
                print("NO")
                direction = 0.250
            
            default:
                print("RUIM")
        }
    }
    
    private func setPosition(for name: String) {
        
    }
    
    private func animateFor(for position: String) {
        if lastMoved != position {
            let texture = TextureManager.shared.getTextureAtlasFrames(for: position)
            animate(in: node, with: texture)
            lastMoved = position
        }
    }

    private func animate(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
    
}
