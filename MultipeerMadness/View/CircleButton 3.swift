//
//  CircleButton.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let blurEffect = UIBlurEffect(style: .light)
//        let vfxView = UIVisualEffectView(effect: blurEffect)
//        
//        self.addSubview(vfxView)
//        vfxView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            vfxView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            vfxView.topAnchor.constraint(equalTo: self.topAnchor),
//            vfxView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7),
//            vfxView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7)
//        ])
//        vfxView.layer.cornerRadius = 25
//        vfxView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
