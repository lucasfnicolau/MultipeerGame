//
//  CustomPeerID.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 09/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import MultipeerConnectivity

class CustomMCPeerID: MCPeerID {
    var pid: Int = -1
    
    override init(displayName myDisplayName: String) {
        super.init(displayName: myDisplayName)
    }
    
    init(pid: Int, withDisplayName displayName: String) {
        super.init(displayName: displayName)
        self.pid = pid
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
