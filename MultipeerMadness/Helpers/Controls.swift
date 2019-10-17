//
//  Controls.swift
//  MultipeerMadness
//
//  Created by Lucas Fernandez Nicolau on 15/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {
    func controllerInputDetected(gamepad: GCExtendedGamepad, element: GCControllerElement, index: Int) {
        if (gamepad.leftThumbstick == element) {
            if (gamepad.leftThumbstick.xAxis.value != 0) {
                
                let index = ServiceManager.peerID.pid
                
                joystick.vX = -CGFloat(gamepad.leftThumbstick.xAxis.value) * 3.20
                joystick.vY = CGFloat(gamepad.leftThumbstick.yAxis.value) * 3.20
                
                guard let velocity = players[index].component(ofType: VelocityComponent.self) else { return }
                velocity.x = joystick.vX
                velocity.y = joystick.vY
                
                if joystick.vX != lastVelocity[0]
                    || joystick.vY != lastVelocity[1] {
                    
                    guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
                    
                    self.send("v:\(ServiceManager.peerID.pid):\(String(format: "%.2f", joystick.vX)):\(String(format: "%.2f", joystick.vY)):\(playerNode.zRotation)")
                    
                }
                
                lastVelocity[0] = joystick.vX
                lastVelocity[1] = joystick.vY
                
                
            } else if (gamepad.leftThumbstick.xAxis.value == 0) {
                joystick.vX = 0
                joystick.vY = 0
                
                 guard let playerNode = players[index].component(ofType: SpriteComponent.self)?.node else { return }
                send("v:\(ServiceManager.peerID.pid):0:0:\(playerNode.zRotation)")
                
                setVelocity([0, 0], on: ServiceManager.peerID.pid)
            }
        }
        // Right Thumbstick
        if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.xAxis.value != 0) {
                print("Controller: \(index), rightThumbstickXAxis: \(gamepad.rightThumbstick.xAxis)")
            }
        }
            // D-Pad
        else if (gamepad.dpad == element) {
            if (gamepad.dpad.xAxis.value != 0) {
                print("Controller: \(index), D-PadXAxis: \(gamepad.rightThumbstick.xAxis)")
            } else if (gamepad.dpad.xAxis.value == 0) {
                // YOU CAN PUT CODE HERE TO STOP YOUR PLAYER FROM MOVING
            }
        }
            // A-Button
        else if (gamepad.buttonA == element) {
            if (gamepad.buttonA.value != 0) {
                print("Controller: \(index), A-Button Pressed!")
            }
        }
        // B-Button
        else if (gamepad.buttonB == element) {
            if (gamepad.buttonB.value != 0) {
                print("Controller: \(index), B-Button Pressed!")
            }
        } else if (gamepad.buttonY == element) {
            if (gamepad.buttonY.value != 0) {
                print("Controller: \(index), Y-Button Pressed!")
            }
        } else if (gamepad.buttonX == element) {
            if (gamepad.buttonX.value != 0) {
                print("Controller: \(index), X-Button Pressed!")
            }
        }
    }
}

extension GameScene {
    
    func ObserveForGameControllers() {
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectControllers), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    
    @objc func connectControllers() {
        //Unpause the Game if it is currently paused
        self.isPaused = false
        //Used to register the Nimbus Controllers to a specific Player Number
        var indexNumber = 0
        // Run through each controller currently connected to the system
        for controller in GCController.controllers() {
            //Check to see whether it is an extended Game Controller (Such as a Nimbus)
            if controller.extendedGamepad != nil {
                controller.playerIndex = GCControllerPlayerIndex.init(rawValue: indexNumber)!
                indexNumber += 1
                setupControllerControls(controller: controller)
            }
        }
    }
    
    // Function called when a controller is disconnected from the Apple TV
    @objc func disconnectControllers() {
        // Pause the Game if a controller is disconnected ~ This is mandated by Apple
        self.isPaused = true
    }
    
    func setupControllerControls(controller: GCController) {
        //Function that check the controller when anything is moved or pressed on it
        controller.extendedGamepad?.valueChangedHandler = {
        (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            // Add movement in here for sprites of the controllers
            self.controllerInputDetected(gamepad: gamepad, element: element, index: controller.playerIndex.rawValue)
        }
    }
}
