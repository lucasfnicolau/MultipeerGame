//
//  PlayerFactory.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 17/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import SpriteKit

class PlayerFactory {
    func createPlayer(ofType type: String) -> Player {
        if (type.isEqual("rambo")) {
          return Player(imageName: "rambo")
        }
        return Player(imageName: "ramboFull")
    }
}
