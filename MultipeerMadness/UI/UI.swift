//
//  UI.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 22/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit
import SpriteKit

class UIFactory {
    var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func createButton(ofType type: String) {
        let button = UIButton(frame: .zero)
        
        guard let sceneView = scene.view else { return }
        sceneView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "\(type)Btn")
        let imgSize = image?.size ?? .zero
        
        button.setBackgroundImage(image, for: .normal)
        
        switch type {
        case "shoot":
            button.addTarget(scene, action: #selector(scene.shoot), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor, constant: -125),
                button.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -25),
                button.widthAnchor.constraint(equalToConstant: imgSize.width / 8),
                button.heightAnchor.constraint(equalToConstant: imgSize.height / 8)
            ])
        case "dash":
            button.addTarget(scene, action: #selector(scene.dash), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: sceneView.trailingAnchor, constant: -25),
                button.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -70),
                button.widthAnchor.constraint(equalToConstant: imgSize.width / 8),
                button.heightAnchor.constraint(equalToConstant: imgSize.height / 8)
            ])
        default:
            return
        }
    }
}
