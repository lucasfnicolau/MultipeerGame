//
//  RoundedVisualEffectView.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 25/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

class RoundedVisualEffectView: UIVisualEffectView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}
