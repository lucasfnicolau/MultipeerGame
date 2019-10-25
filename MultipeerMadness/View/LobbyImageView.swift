//
//  LobbyImageView.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class LobbyImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.75
        self.layer.cornerRadius = self.frame.width / 2
    }

}
