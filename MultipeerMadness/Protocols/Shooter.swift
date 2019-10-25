//
//  Shooter.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 16/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import SpriteKit

protocol Shooter {
    func shoot(index: Int, zRotation: CGFloat)
    func reload()
}
