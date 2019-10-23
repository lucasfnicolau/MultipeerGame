//
//  MCNearbyService.swift
//  MultipeerMadness
//
//  Created by Matheus Silva on 10/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ServiceManager: NSObject {
    
    static var peerID: CustomMCPeerID!

    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ServiceType = "near"
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    var sceneDelegate: SceneDelegate?

    lazy var session: MCSession = {
        let session = MCSession(peer: ServiceManager.peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()

    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: ServiceManager.peerID, discoveryInfo: nil, serviceType: ServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: ServiceManager.peerID, serviceType: ServiceType)

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
        
        switch state {
            case .connected:
                
                let playersNumber = session.connectedPeers.count
                
                if (ServiceManager.peerID.pid == 0) {
                    send(value: "players:\(playersNumber)")
                    sceneDelegate?.createEntities(quantity: playersNumber)
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
        
//        NSLog("%@", "didReceiveData: \(data)")
        
        DispatchQueue.main.async {
        
            guard let value = String(data: data, encoding: .utf8) else { return }
            let keyValue = value.split(separator: ":")
            
            if keyValue[0] == "players" {
                let playersNumber = keyValue[1].int()
                
                if ServiceManager.peerID.pid == -1 {
                    ServiceManager.peerID.pid = playersNumber
                }
                self.sceneDelegate?.createEntities(quantity: playersNumber)
                
            } else if keyValue[0] == "v" {
                let index = Int(keyValue[1]) ?? 0
                let v = [
                    keyValue[2].cgFloat(),
                    keyValue[3].cgFloat()
                ]
                self.sceneDelegate?.setVelocity(v, on: index)
                
                if keyValue[4] != "-" {
                    let r = keyValue[4].cgFloat()
                    self.sceneDelegate?.setRotation(r, on: index)
                }
            } else if keyValue[0] == "fire" {
                let index = keyValue[1].int()
                self.sceneDelegate?.announceShooting(on: index)
            } else {
                let id = keyValue[0].int()
                let x = keyValue[1].cgFloat()
                let y = keyValue[2].cgFloat()
                self.sceneDelegate?.move(onIndex: id, to: (x, y))
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
