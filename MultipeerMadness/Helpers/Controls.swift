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
                
                velocities[index] = [joystick.vX, joystick.vY]
                
                if joystick.vX != lastVelocity[0]
                    || joystick.vY != lastVelocity[1] {
                    
                    self.send("v:\(ServiceManager.peerID.pid):\(String(format: "%.2f", joystick.vX)):\(String(format: "%.2f", joystick.vY))")
                    
                }
                
                lastVelocity[0] = joystick.vX
                lastVelocity[1] = joystick.vY
                
                
            } else if (gamepad.leftThumbstick.xAxis.value == 0) {
                joystick.vX = 0
                joystick.vY = 0
                
                send("v:\(ServiceManager.peerID.pid):0:0")
                
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
