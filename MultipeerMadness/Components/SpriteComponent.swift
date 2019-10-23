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
    var textures = [[SKTexture]]()
    let textureNames = ["N","NE","L","SE","S","SO","O","NO"]
    var lastMoved = ""
    var owner: GKEntity?

    init(texture: SKTexture, owner: GKEntity) {
        node = CustomNode(texture: texture, color: .white, size: texture.size(), owner: owner)
        super.init()
        loadTextures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runTo(zRotation: CGFloat) {
        // 0.5 = 90 graus
        // x = 0.5 / 2
        // y = 0.5 / 4
        switch zRotation / .pi {
            
            case -0.125 ..< 0.125:
                print("N")
                animateFor(for: "N")
            
            case -0.375 ..< -0.125:
                print("NE")
            
            case -0.625 ..< -0.375:
                print("L")
                animateFor(for: "L")
            
            case -0.875 ..< -0.625:
                print("SE")
            
            case -1.125 ..< -0.875:
                print("S")
                animateFor(for: "S")
            
            case -1.375 ..< -1.125:
                print("SO")
            
            case -1.5 ..< -1.375:
                print("O")
                animateFor(for: "O")
                
            
            case 0.375 ..< 0.5:
                print("O")
                animateFor(for: "O")
                
            
            case 0 ..< 0.375:
                print("NO")
            default:
                print("RUIM")
        }
    }
    
    private func animateFor(for position: String) {
        if lastMoved != position {
            guard let index = textureNames.firstIndex(of: position) else { return }
            animate(in: node, with: textures[index])
            lastMoved = position
        }
    }

    private func animate(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
    
    private func buildAtlasTexture(to name: String) -> [SKTexture] {
      let animatedAtlas = SKTextureAtlas(named: name)
      var frames: [SKTexture] = []

      let numImages = animatedAtlas.textureNames.count
      for i in 0..<numImages {
        let textureName = "\(name)_0\(i)"
        frames.append(animatedAtlas.textureNamed(textureName))
      }
      return frames
    }
    
    private func loadTextures() {
        for name in textureNames {
            textures.append(buildAtlasTexture(to: name))
        }
    }
}
