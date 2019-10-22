//
//  Helpers.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 12/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import UIKit

func mod(_ value: CGFloat) -> CGFloat {
    return value < 0 ? value * -1 : value
}

extension CGPoint {
    mutating func normalize() {
//        let b = CGSize(width: 1024.0, height: 1366.0)
        let b = UIScreen.main.bounds
        self.x = 1 - ((b.width - self.x)/(b.width))
        self.y = 1 - ((b.height - self.y)/(b.height))
    }
}

extension String {
    func cgFloat() -> CGFloat {
        return CGFloat(Float(self) ?? 0)
    }
    
    func float() -> Float {
        return Float(self) ?? 0
    }
    
    func int() -> Int {
        return Int(self) ?? 0
    }
}

extension Substring {
    func cgFloat() -> CGFloat {
        return CGFloat(Float(String(self)) ?? 0)
    }
    
    func float() -> Float {
        return Float(String(self)) ?? 0
    }
    
    func int() -> Int {
        return Int(String(self)) ?? 0
    }
}
