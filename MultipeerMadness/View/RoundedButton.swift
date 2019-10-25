//
//  RoundedButton.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
