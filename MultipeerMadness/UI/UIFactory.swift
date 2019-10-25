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
    
    func createButton(ofType type: String) -> CircleButton {
        let button = CircleButton(frame: .zero)
        
        guard let sceneView = scene.view else { return CircleButton() }

        sceneView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "\(type)Btn")
        let imgSize = image?.size ?? .zero
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        sceneView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case "shoot":
            button.addTarget(scene, action: #selector(scene.shoot), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.trailingAnchor, constant: -125),
                button.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -25),
                button.widthAnchor.constraint(equalToConstant: imgSize.width / 5),
                button.heightAnchor.constraint(equalToConstant: imgSize.height / 5)
            ])
        case "dash":
            button.addTarget(scene, action: #selector(scene.dash), for: .touchUpInside)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.trailingAnchor, constant: -25),
                button.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -90),
                button.widthAnchor.constraint(equalToConstant: imgSize.width / 5),
                button.heightAnchor.constraint(equalToConstant: imgSize.height / 5)
            ])
        default:
            return CircleButton()
        }
        
        return button
    }
    
    func createLabel(ofType type: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        
        guard let sceneView = scene.view else { return UILabel() }
        
        switch type {
        case "score":
            label.text = "Kills: 0"
            
            let blurEffect = UIBlurEffect(style: .light)
            let vfxView = UIVisualEffectView(effect: blurEffect)
            
            sceneView.addSubview(vfxView)
            vfxView.translatesAutoresizingMaskIntoConstraints = false
            
            vfxView.contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                vfxView.leadingAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                vfxView.topAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.topAnchor, constant: 4),
                vfxView.widthAnchor.constraint(equalToConstant: 80),
                vfxView.heightAnchor.constraint(equalToConstant: 50),
                
                label.leadingAnchor.constraint(equalTo: vfxView.contentView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: vfxView.contentView.trailingAnchor),
                label.topAnchor.constraint(equalTo: vfxView.contentView.topAnchor),
                label.bottomAnchor.constraint(equalTo: vfxView.contentView.bottomAnchor)
            ])
            vfxView.layer.cornerRadius = 25
            vfxView.clipsToBounds = true
            
        default:
            return UILabel()
        }
        
        return label
    }
}
