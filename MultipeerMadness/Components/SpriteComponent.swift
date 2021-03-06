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
    var direction: PlayerDirection = .back
    
    init(texture: SKTexture, owner: GKEntity) {
        node = CustomNode(texture: texture, color: .white, size: texture.size(), owner: owner)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateDie(index: Int) {
        let position = "die_nothing_front_\(index)"
        let texture = TextureManager.shared.getTextureAtlasFrames(for: position)
        animateFrames(in: node, with: texture) { }
    }
    
    func animateIdle(to zRotation: CGFloat, _ index: Int) {
        getDirection(zRotation: zRotation)
        animateTo(state: "idle", action: "nothing", direction: direction.rawValue , player: index)
    }
    
    func animateRunControl(to zRotation: CGFloat, _ index: Int) {
        if state != "die" {
            getDirectionControl(zRotation: zRotation)
            animateTo(state: "run", action: "nothing", direction: direction.rawValue, player: index)
        }
    }
    
    func animateRun(to zRotation: CGFloat, _ index: Int) {
        if state != "die" {
            getDirection(zRotation: zRotation)
            animateTo(state: "run", action: "nothing", direction: direction.rawValue, player: index)
        }
    }
    
    func animateRunShoot(to zRotation: CGFloat, _ index: Int) {
        if state != "die" {
            getDirectionShoot(zRotation: zRotation)
            animateTo(state: "run", action: "shooting", direction: direction.rawValue, player: index)
        }
    }
    
    func getDirectionControl(zRotation: CGFloat) {
        
        // 0.5 == 90 graus
        switch zRotation / .pi {
            
        case 0.75 ... 0.25:
            node.zRotation = zRotation
            direction = .back
            
        case -0.75 ... 0.25:
            node.zRotation = zRotation + .pi / 2
            direction = .right //("back_right")
            
        case -0.75 ... -0.25:
            node.zRotation = zRotation + .pi
            direction = .front //("front_right")
            
        case -1 ... -0.75:
            node.zRotation = zRotation - .pi / 2
            direction = .left //("front_left")
            
        case 0.75 ... 1:
            node.zRotation = zRotation - .pi / 2
            direction = .left
            
        default:
            direction = .left
            
        }
    }
    
    func getDirection(zRotation: CGFloat) {
        
        // 0.5 == 90 graus
        
        switch zRotation / .pi {
            
        case -0.125 ... 0.125:
            node.zRotation = zRotation
            direction = .back
            
        case -0.375 ... -0.125:
            node.zRotation = zRotation + .pi / 2
            direction = .right //("back_right")
            
        case -0.625 ... -0.375:
            node.zRotation = zRotation + .pi / 2
            direction = .right
            
        case -0.875 ... -0.625:
            node.zRotation = zRotation + .pi
            direction = .front //("front_right")
            
        case -1.125 ... -0.875:
            node.zRotation = zRotation - .pi
            direction = .front
            
        case -1.375 ... -1.125:
            node.zRotation = zRotation - .pi / 2
            direction = .left //("front_left")
            
        case -1.5 ... -1.375:
            node.zRotation = zRotation - .pi / 2
            direction = .left
            
        case 0.375 ... 0.5:
            node.zRotation = zRotation - .pi / 2
            direction = .left
            
        case 0.125 ... 0.375:
            node.zRotation = zRotation - .pi / 2
            direction = .left //("back_left")
            
        default:
            direction = .left
            
        }
    }
    
    func getDirectionShoot(zRotation: CGFloat) {
        
        // 0.5 == 90 graus
        switch zRotation / .pi {
        case -0.125 ... 0.125:
            direction = .back
            
        case -0.375 ... -0.125:
            direction = .right //("back_right")
            
        case -0.625 ... -0.375:
            direction = .right
            
        case -0.875 ... -0.625:
            direction = .front //("front_right")
            
        case -1.125 ... -0.875:
            direction = .front
            
        case -1.375 ... -1.125:
            direction = .left //("front_left")
            
        case -1.5 ... -1.375:
            direction = .left
            
        case 0.375 ... 0.5:
            direction = .left
            
        case 0.125 ... 0.375:
            direction = .left //("back_left")
            
        default:
            direction = .left
            
        }
    }
    
    private func animateTo(state: String, action: String, direction: String, player: Int) {
        var position = "\(state)_\(action)_\(direction)_\(player)"

        if lastMoved != position {
            var texture = TextureManager.shared.getTextureAtlasFrames(for: position)
            if texture.count > 0 {
                if action == "shooting" || state == "die" {
                    animateFrames(in: node, with: texture) {
                        position = "idle_\(action)_\(direction)_\(player)"
                        texture = TextureManager.shared.getTextureAtlasFrames(for: position)
                        self.animateFramesForever(in: self.node, with: texture)
                        self.lastMoved = position
                    }
                } else  {
                    animateFramesForever(in: node, with: texture)
                    lastMoved = position
                }
                
                
            } else {
                NSLog("ERRO: Falha ao carregar os frames.")
            }
            
        }
    }
    
    private func animateFrames(in obj: SKSpriteNode, with frames: [SKTexture], withCompletion completion: @escaping () -> Void) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        let completion = SKAction.run {
            completion()
        }
        obj.run(SKAction.sequence([animate, completion]), withKey: "moved")
    }
    
    private func animateFramesForever(in obj: SKSpriteNode, with frames: [SKTexture]) {
        let animate = SKAction.animate(with: frames, timePerFrame: 1 / (TimeInterval(frames.count)))
        
        obj.run(SKAction.repeatForever(animate), withKey: "moved")
    }
}
