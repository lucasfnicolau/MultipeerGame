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
    
    func runTo(zRotation: CGFloat,_ index: Int) {
        // 0.5 = 90 graus
        // x = 0.5 / 2
        // y = 0.5 / 4
        node.zRotation = zRotation - .pi / 2
        
        
        switch zRotation / .pi {
            
            case -0.125 ..< 0.125:
                print("N")
            
            case -0.375 ..< -0.125:
                print("NE")
            
            case -0.625 ..< -0.375:
                print("L")

            case -0.875 ..< -0.625:
                print("SE")
            
            case -1.125 ..< -0.875:
                print("S")
                            
            case -1.375 ..< -1.125:
                print("SO")
            
            case -1.5 ..< -1.375:
                print("O")
                animateFor(for: "run_nothing_left_\(index)")
                
            case 0.375 ..< 0.5:
                print("O")
                animateFor(for: "run_nothing_left_\(index)")
            
            case 0.125 ..< 0.375:
                print("NO")
            
            default:
                print("RUIM")
        }
    }
    
    private func animateFor(for position: String) {
        if lastMoved != position {
            let texture = TextureManager.shared.getTextureAtlasFrames(for: position)
            if texture.count > 0 {
                animate(in: node, with: texture)
                lastMoved = position
            } else {
                NSLog("ERRO: Falha ao carregar os frames.")
            }
            
        }
    }

    private func animate(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
    
}
