//
//  LobbyDelegate.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

protocol LobbyDelegate {
    func updatePlayers(to number: Int)
    func startGame()
}
