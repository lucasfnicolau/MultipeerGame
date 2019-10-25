//
//  SoundManager.swift
//  MultipeerMadness
//
//  Created by Leonardo Oliveira on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import AVFoundation

enum SoundLoadResponse: Error {
    case success(audio: AVAudioPlayer)
    case error(description: String)
}

public class SoundManager: NSObject {
    
    static func getAudio(name: String, withCompletion completion: (SoundLoadResponse) -> Void) {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            completion(SoundLoadResponse.error(description: "error"))
            return
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        do {
            let audio = try AVAudioPlayer(contentsOf: fileURL)
            completion(SoundLoadResponse.success(audio: audio))
            
        } catch {
            completion(SoundLoadResponse.error(description: "error"))
        }
    }
    
}
