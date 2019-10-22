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
    var owner: GKEntity?

    init(texture: SKTexture, owner: GKEntity) {
        node = CustomNode(texture: texture, color: .white, size: texture.size(), owner: owner)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
