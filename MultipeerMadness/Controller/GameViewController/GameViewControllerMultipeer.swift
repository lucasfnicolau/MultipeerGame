//
//  GameViewControllerMultipeer.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 09/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import MultipeerConnectivity

extension GameViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      
        switch state {
        case .connected:
            let playersNumber = MultipeerManager.mcSession.connectedPeers.count
        
            if (MultipeerManager.peerID.pid == 0) {
                send("players:\(playersNumber)")
                scene.addPlayer(index: playersNumber)
            }
            
            print("Connected: \(MultipeerManager.peerID.displayName)")
        case .connecting:
            print("Connecting: \(MultipeerManager.peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(MultipeerManager.peerID.displayName)")
        @unknown default:
            print("fatal error")
        }
    }
    
    func send(_ value: String) {
        guard let data = value.data(using: .utf8) else { return }
        do {
            try MultipeerManager.mcSession.send(data, toPeers: MultipeerManager.mcSession.connectedPeers, with: .unreliable)
        }
        catch {
            print("Error sending message")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      DispatchQueue.main.async { [unowned self] in
    
        guard let value = String(data: data, encoding: .utf8) else { return }
        let keyValue = value.split(separator: ":")
        
        if keyValue[0] == Substring("players") {
            let playersNumber = Int(keyValue[1]) ?? 1
            if MultipeerManager.peerID.pid == -1 {
                MultipeerManager.peerID.pid = playersNumber
            }
            for index in self.scene.circles.count ... playersNumber {
                self.scene.addPlayer(index: index)
            }
        } else {
            let id = Int(String(keyValue[0])) ?? 0
            let x = Float(String(keyValue[1])) ?? 0
            let y = Float(String(keyValue[2])) ?? 0
            
            self.scene.circles[id].position.x = CGFloat(x)
            self.scene.circles[id].position.y = CGFloat(y)
        }
        
      }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
