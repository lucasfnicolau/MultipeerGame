//
//  Joystick.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 09/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit

class Joystick: SKShapeNode {
    
    let knob = SKShapeNode(circleOfRadius: 40)
    var vX: CGFloat = 0.0
    var vY: CGFloat = 0.0
    var isActive: Bool = false
    
    func configure(in scene: SKScene) {
        self.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.setScale(1)
        self.zPosition = 1.0
        self.alpha = 0.2
        
        knob.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        knob.strokeColor = .clear
        knob.position = self.position
        knob.zPosition = 2.0
        knob.alpha = 0.2
        knob.setScale(0.5)
        scene.addChild(knob)
    }
}
