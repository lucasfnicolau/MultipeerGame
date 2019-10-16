//
//  MCNearbyService.swift
//  MultipeerMadness
//
//  Created by Matheus Silva on 10/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ServiceDelegate {
    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String])
}

class ServiceManager: NSObject {
    
    static var peerID: CustomMCPeerID!

    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ServiceType = "near"

    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    var delegate: ServiceDelegate?
    var sceneDelegate: SceneDelegate?

    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()

    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ServiceType)

        super.init()
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }

    func send(value: String) {
        NSLog("%@", "\(value) to \(session.connectedPeers.count) peers")

        if session.connectedPeers.count > 0 {
            guard let data = value.data(using: .utf8) else { return }
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    public func createSession() {
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    public func enterSession() {
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }

}

extension ServiceManager: MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }

}

extension ServiceManager: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 100)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }

}

extension ServiceManager: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        //Mostra na tela dispositivos conectados
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
        session.connectedPeers.map{$0.displayName})
        
        switch state {
            case .connected:
                
                let playersNumber = session.connectedPeers.count
                
                if (ServiceManager.peerID.pid == 0) {
                    send(value: "players:\(playersNumber)")
                    sceneDelegate?.addNodes(quantity: playersNumber)
                }
                
                print("Connected: \(ServiceManager.peerID.displayName)")
            case .connecting:
                print("Connecting: \(ServiceManager.peerID.displayName)")
            case .notConnected:
                print("Not Connected: \(ServiceManager.peerID.displayName)")
            @unknown default:
                print("fatal error")
        }

        
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        NSLog("%@", "didReceiveData: \(data)") // REMOVE
        
        DispatchQueue.main.async {
        
            guard let value = String(data: data, encoding: .utf8) else { return }
            let keyValue = value.split(separator: ":")
            
            if keyValue[0] == Substring("players") {
                let playersNumber = Int(keyValue[1]) ?? 1
                
                if ServiceManager.peerID.pid == -1 {
                    ServiceManager.peerID.pid = playersNumber
                }
                self.sceneDelegate?.addNodes(quantity: playersNumber)
                
            } else if keyValue[0] == Substring("v") {
                let index = Int(keyValue[1]) ?? 0
                let v = [
                    CGFloat(Float(keyValue[2]) ?? 0),
                    CGFloat(Float(keyValue[3]) ?? 0)
                ]
                self.sceneDelegate?.setVelocity(v, on: index)
            } else {
                let id = Int(String(keyValue[0])) ?? 0
                let x = Float(String(keyValue[1])) ?? 0
                let y = Float(String(keyValue[2])) ?? 0
                
                self.sceneDelegate?.move(onIndex: id, by: (CGFloat(x), CGFloat(y)))
            }
            
          }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

}
