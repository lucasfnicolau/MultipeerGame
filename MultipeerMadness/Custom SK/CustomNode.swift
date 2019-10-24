//
//  CustomNode.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 22/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit
import GameplayKit

class CustomNode: SKSpriteNode {
    var owner: GKEntity?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(texture: SKTexture?, color: UIColor, size: CGSize, owner: GKEntity) {
        self.init(texture: texture, color: color, size: size)
        self.owner = owner
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
